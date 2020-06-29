library(RMariaDB)

getSQLconnection <- function(password) {
  con <- dbConnect(
    drv = RMariaDB::MariaDB(),
    username = "grzegorz",
    password = password,
    host = "192.168.1.103",
    db='air'
  )
  return(con)
}
