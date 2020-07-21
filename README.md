# Air Quality

[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip) 
[![Build Status](https://travis-ci.com/GrzegorzMika/air-quality.svg?branch=master)](https://travis-ci.com/GrzegorzMika/air-quality)

1. A running instance of `MySQL` or `MariaDB` server is required in a local network.
2. In case of `MariaDB` to allow conection to database from any port - in file 
`/etc/mysql/mariadb.conf.d/50-server.cnf ` set `bind-address = 0.0.0.0`.
3. Export database owner password to environmental variable `export DB_PSSWD=password` and database owner name to `export DB_OWNER=owner`.
