library(RMariaDB)
library(ggplot2)
library(shiny)
library(jsonlite)

####### database credentials ######

username <- Sys.getenv("MYSQL_USER")
password <- Sys.getenv("MYSQL_PASSWORD")
host <- Sys.getenv("MYSQL_HOST")

####### parameters ######

setup <- fromJSON("setup_dashboard.json")

NOTIFICATION_RANGE <- setup$notification_range
NOTIFICATION_DURATION <- setup$notification_duration
DATABASE <- setup$database
SMOOTHING <- setup$default_smoothing
AUTOINVALIDATE <- setup$autoInvalidate
UIINVALIDATE <- setup$uiInvalidate
NOTIFICATIONSINVALIDATE <- setup$notificationsInvalidate

####### timers ######

autoInvalidate <- reactiveTimer(1000 * 60 * AUTOINVALIDATE)
uiInvalidate <- reactiveTimer(1000 * 60 * UIINVALIDATE)
notificationsInvalidate <- reactiveTimer(1000 * 60 * NOTIFICATIONSINVALIDATE)

####### database connection ######

getSQLconnection <- function(username, password, host) {
  con <- dbConnect(
    drv = RMariaDB::MariaDB(),
    username = username,
    password = password,
    host = host,
    db = DATABASE
  )
  return(con)
}

con <- getSQLconnection(username, password, host)

####### notification logic ######

generate_notifications <- function() {
  notificationsInvalidate()

  query <- paste0(
    'SELECT * 
      FROM warnings
      WHERE timestamp > "', strftime(strptime(Sys.time() - 60 * 60 * NOTIFICATION_RANGE, "%Y-%m-%d %H:%M:%S", "GMT")), '" AND timestamp < "',
    strftime(strptime(Sys.time(), "%Y-%m-%d %H:%M:%S", "GMT")), '";'
  )

  q <- dbSendQuery(con, query)
  notifications <- dbFetch(q, n = -1)
  num <- dim(notifications)[1]
  dbClearResult(q)
  notifications$timestamp <- as.POSIXct(strftime(notifications$timestamp, "%Y-%m-%d %H:%M:%S", "GMT", usetz = TRUE))

  if (num == 0) {
    return(list())
  } else {
    lapply(1:num, function(i) {
      notificationItem(
        text = tags$div("Threshold has been exeeded:",
          tags$br(),
          notifications[i, "message"],
          tags$br(),
          "Observed value: ", round(notifications[i, "value"], 2),
          style = "display: inline-block; vertical-align: middle;"
        ),
        icon("heartbeat"),
        status = "danger"
      )
    })
  }
}

get_new_warning <- function() {
  query <- paste0(
    'SELECT * 
      FROM warnings
      WHERE timestamp > "', strftime(strptime(Sys.time() - 90, "%Y-%m-%d %H:%M:%S", "GMT")), '" ORDER BY timestamp DESC LIMIT 1;'
  )
  q <- dbSendQuery(con, query)
  notifications <- dbFetch(q, n = -1)
  num <- dim(notifications)[1]
  dbClearResult(q)
  notifications$timestamp <- as.POSIXct(strftime(notifications$timestamp, "%Y-%m-%d %H:%M:%S", "GMT", usetz = TRUE))

  if (num > 0) {
    text <- list(icon("bolt"), tags$div("Threshold has been exeeded:",
      tags$br(),
      notifications[1, "message"],
      tags$br(),
      "Observed value: ", round(notifications[1, "value"], 2),
      style = "display: inline-block; vertical-align: middle; color: black; font-size: 14px; font-weight: bold;"
    ))
    showNotification(text, duration = NOTIFICATION_DURATION, type = "warning")
  }
}


####### UI wrappers ######

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
  temperature_tbl$timestamp <- as.POSIXct(strftime(temperature_tbl$timestamp, "%Y-%m-%d %H:%M:%S", "GMT", usetz = TRUE))

  ggplot(temperature_tbl, aes(x = timestamp, y = mv_temperature)) +
    geom_line() +
    theme_bw() +
    theme(
      axis.text.x = element_text(angle = 90, vjust = 0, hjust = 0),
      text = element_text(size = 14, face = "bold")
    ) +
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
  humidity_tbl$timestamp <- as.POSIXct(strftime(humidity_tbl$timestamp, "%Y-%m-%d %H:%M:%S", "GMT", usetz = TRUE))

  ggplot(humidity_tbl, aes(x = timestamp, y = mv_humidity)) +
    geom_line() +
    theme_bw() +
    theme(
      axis.text.x = element_text(angle = 90, vjust = 0, hjust = 0),
      text = element_text(size = 14, face = "bold")
    ) +
    labs(title = "Humidity") +
    xlab("Date") +
    ylab("%")
}

get_current_temperature <- function() {
  query <- dbSendQuery(con, "SELECT temperature FROM temperature ORDER BY timestamp DESC LIMIT 1;")

  temp <- dbFetch(query, n = 1)
  dbClearResult(query)

  paste0("Temperature: ", round(temp, 1), "\u00B0C")
}

get_current_humidity <- function() {
  query <- dbSendQuery(con, "SELECT humidity FROM humidity ORDER BY timestamp DESC LIMIT 1;")

  hum <- dbFetch(query, n = 1)
  dbClearResult(query)

  paste0("Humidity: ", round(hum, 1), "%")
}

get_current_time <- function() {
  query <- dbSendQuery(con, "SELECT timestamp FROM humidity ORDER BY timestamp DESC LIMIT 1;")

  time <- dbFetch(query, n = 1)
  dbClearResult(query)

  paste0("Last update time: ", format(strptime(strftime(time$timestamp, "%H:%M:%S", "GMT", usetz = TRUE), "%H:%M:%S"), "%H:%M:%S"))
}
