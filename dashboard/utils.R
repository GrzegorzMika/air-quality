library(RMariaDB)
library(ggplot2)
library(purrr)

username <- Sys.getenv("MYSQL_USER")
password <- Sys.getenv("MYSQL_PASSWORD")
host <- Sys.getenv("MYSQL_HOST")

getSQLconnection <- function(username, password, host) {
  con <- dbConnect(
    drv = RMariaDB::MariaDB(),
    username = username,
    password = password,
    host = host,
    db = "air"
  )
  return(con)
}

con <- getSQLconnection(username, password, host)

plot_temperature <- function(start, stop, smoothing) {
  
  query <- paste0("SELECT * FROM (
                        SELECT
                            timestamp,
                            avg(temperature) OVER (ORDER BY timestamp ROWS ", smoothing - 1, ' PRECEDING) AS mv_temperature
                        FROM temperature
                        ORDER BY timestamp) as moving_temperature
                  WHERE timestamp > "', start, '" AND timestamp < "', stop, '";')
  
  q <- dbSendQuery(con, query)
  temperature_tbl <- dbFetch(q, n = -1)
  dbClearResult(q)
  
  ggplot(temperature_tbl, aes(x = timestamp, y = mv_temperature)) +
    geom_line() +
    theme_bw() +
    theme(axis.text.x = element_text(angle = 90, vjust = 0, hjust = 0),
          text = element_text(size=14, face="bold")) +
    labs(title = "Temperature") +
    xlab("Date") +
    ylab("\u00B0C")
}

plot_humidity <- function(start, stop, smoothing) {
  
  query <- paste0("SELECT * FROM (
                        SELECT
                            timestamp,
                            avg(humidity) OVER (ORDER BY timestamp ROWS ", smoothing - 1, ' PRECEDING) AS mv_humidity
                        FROM humidity
                        ORDER BY timestamp) as moving_humidity
                  WHERE timestamp > "', start, '" AND timestamp < "', stop, '";')
  
  q <- dbSendQuery(con, query)
  humidity_tbl <- dbFetch(q, n = -1)
  dbClearResult(q)
  
  ggplot(humidity_tbl, aes(x = timestamp, y = mv_humidity)) +
    geom_line() +
    theme_bw() +
    theme(axis.text.x = element_text(angle = 90, vjust = 0, hjust = 0),
          text = element_text(size=14, face="bold")) +
    labs(title = "Humidity") +
    xlab("Date") +
    ylab("%")
}

get_current_temperature <- function() {
  
  query <- dbSendQuery(con, "SELECT temperature FROM temperature ORDER BY timestamp DESC LIMIT 1")
  
  temp <- dbFetch(query, n = 1)
  dbClearResult(query)

  paste0("Temperature: ", round(temp, 1), "\u00B0C")
}

get_current_humidity <- function() {
  
  query <- dbSendQuery(con, "SELECT humidity FROM humidity ORDER BY timestamp DESC LIMIT 1")
  
  hum <- dbFetch(query, n = 1)
  dbClearResult(query)

  paste0("Humidity: ", round(hum, 1), "%")
}

get_current_time <- function() {
  
  query <- dbSendQuery(con, "SELECT timestamp FROM humidity ORDER BY timestamp DESC LIMIT 1")
  
  time <- dbFetch(query, n = 1)
  dbClearResult(query)
  
  paste0("Last update time: ", format(time, "%H:%M:%S"))
}
