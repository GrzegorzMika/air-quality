#!/bin/bash

source ../credentials.sh
YEAR=$(date +%Y)
MONTH=$(date +%m)
DAY=$(date +%d)
mkdir -p air/$YEAR/$MONTH/$DAY
mysqldump -u$MYSQL_USER -p$MYSQL_PASSWORD air > air/$YEAR/$MONTH/$DAY/backup.sql