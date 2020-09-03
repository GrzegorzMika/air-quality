#!/bin/bash

YEAR=$(date +%Y)
MONTH=$(date +%m)
DAY=$(date +%d)
mkdir -p air/$YEAR/$MONTH/$DAY
mysqldump -u$DB_OWNER -p$DB_PSSWD air > air/$YEAR/$MONTH/$DAY/backup.sql