##To get list of databases, include a query in a script like: SELECT schema_name  FROM information_schema.schemata;
#Run the script: ./list_database.sh 2> /dev/null | awk '{print $1}' | tail -n +2 > database_list.txt

#!/bin/bash

DBUSER='root'
DBPASS='password'
DB='database_list.txt'

while read line; do
mysql -u$DBUSER -p$DBPASS -e "drop database $line;"
done < $DB
