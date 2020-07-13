# Air Quality

1. A running instance of `MySQL` or `MariaDB` server is required in a local network.
2. In case of `MariaDB` to allow conection to database from any port - in file 
`/etc/mysql/mariadb.conf.d/50-server.cnf ` set `bind-address = 0.0.0.0`.
3. Export database owner password to environmental variable `export DB_PSSWD=password` and database name to `export DB_OWNER=owner`.
