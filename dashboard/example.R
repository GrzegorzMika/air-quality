library(RMariaDB)

getSQLconnection <- function() {
  con <- dbConnect(
    drv = RMariaDB::MariaDB(),
    username = "grzegorz",
    password = "loldupa77.",
    host = "192.168.1.103",
    db='air'
  )
  return(con)
}

con <- getSQLconnection()
res <- dbListTables(con)
res <- dbSendQuery(con, "select * from humidity")
data <- dbFetch(res)
print(data)
