#!/bin/bash
YEAR=$(date +%Y)
MONTH=$(date +%m)
DAY=$(date +%d)
HOUR=$(date +%H)
mkdir -p $YEAR/$MONTH/$DAY/$HOUR
mysqldump -uroot -p$DB_PSSWD air > $YEAR/$MONTH/$DAY/$HOUR/backup.sql