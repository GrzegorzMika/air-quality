library(RMariaDB)
library(dplyr)
library(dbplyr)
library(ggplot2)

source("utils.R")

plot_temp <- function(start, stop) {
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

plot_hum <- function(start, stop) {
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

plot_temp(as.Date("2020-07-03"), as.Date("2020-07-08"))
plot_hum(as.Date("2020-07-03"), as.Date("2020-07-08"))

dbDisconnect(con)
