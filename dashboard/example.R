library(RMariaDB)
library(dplyr)
library(dbplyr)
library(ggplot2)
library(purrr)

source("utils.R")
# con <- getSQLconnection()
# res <- dbListTables(con)
# res <- dbSendQuery(con, "select * from humidity")
# data <- dbFetch(res)
# print(data)

temperature <- tbl(con, "temperature")
humidity <- tbl(con, "humidity")

plot_temp <- function(start, stop) {
  temperature %>%
    filter(timestamp >= start & timestamp <= stop) %>%
    collect() %>%
    ggplot(aes(x = timestamp, y = temperature)) +
    geom_line() +
    theme_classic() +
    theme(axis.text.x = element_text(angle = 90, vjust = 0, hjust = 0)) +
    labs(title = "Temperature") +
    xlab("Date") +
    ylab("Celcious")
}

plot_hum <- function(start, stop) {
  humidity %>%
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

# plot_temp(as.Date('2020-06-30'), as.Date('2020-07-01'))
plot_hum(as.Date("2020-06-30"), as.Date("2020-07-02"))


dbDisconnect(con)
