library(RMariaDB)

getSQLconnection <- function() {
  con <- dbConnect(
    drv = RMariaDB::MariaDB(),
    username = "grzegorz",
    password = rstudioapi::askForPassword("Database password"),
    host = "192.168.1.103",
    db='air'
  )
  return(con)
}

con <- getSQLconnection()
