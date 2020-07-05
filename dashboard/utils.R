library(RMariaDB)
library(dplyr)
library(dbplyr)
library(ggplot2)
library(purrr)


getSQLconnection <- function() {
  con <- dbConnect(
    drv = RMariaDB::MariaDB(),
    username = "grzegorz",
    # password = rstudioapi::askForPassword("Database password"),
    password = "loldupa77.",
    host = "192.168.1.103",
    db = "air"
  )
  return(con)
}

con <- getSQLconnection()

plot_temperature <- function(start, stop) {
  tbl(con, "temperature") %>%
    filter(timestamp >= start & timestamp <= stop) %>%
    collect() %>%
    ggplot(aes(x = timestamp, y = temperature)) +
    geom_line() +
    theme_bw() +
    theme(axis.text.x = element_text(angle = 90, vjust = 0, hjust = 0)) +
    labs(title = "Temperature") +
    xlab("Date") +
    ylab("Celcious")
}

plot_humidity <- function(start, stop) {
  tbl(con, "humidity") %>%
    filter(timestamp >= start & timestamp <= stop) %>%
    collect() %>%
    ggplot(aes(x = timestamp, y = humidity)) +
    geom_line() +
    theme_bw() +
    theme(axis.text.x = element_text(angle = 90, vjust = 0, hjust = 0)) +
    labs(title = "Humidity") +
    xlab("Date") +
    ylab("%")
}

get_current_temperature <- function() {
  query <- dbSendQuery(con, "SELECT temperature FROM temperature ORDER BY timestamp DESC LIMIT 1")
  temp <- dbFetch(query, n = 1) %>% flatten_dbl()
  dbClearResult(query)

  paste0("Current temperature: ", round(temp, 2), " C")
}

get_current_humidity <- function() {
  query <- dbSendQuery(con, "SELECT humidity FROM humidity ORDER BY timestamp DESC LIMIT 1")
  hum <- dbFetch(query, n = 1) %>% flatten_dbl()
  dbClearResult(query)

  paste0("Current humidity: ", round(hum, 2), " %")
}
