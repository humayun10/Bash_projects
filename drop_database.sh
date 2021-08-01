#!/bin/bash

DBUSER='root'
DBPASS='password'
DB='database_list.txt'

while read line; do
mysql -u$DBUSER -p$DBPASS -e "drop database $line;"
done < $DB
