#Pupose of this script is to print 10 processes that take up the most memory and sort it from the lowest to the highest.
##first i used ps to print pid, memory and command and sorted by memory. Then I printed the first 11 lines of that output and deleted the first line and sorted each line by column 2 starting with the lowest number. 
##I then printed MEMORY and COMMAND column and separated it with ":", this is so that I could use delimeter for the next step. This will all be stored in a variable.
#I printed output 'PID' and 'COMMAND' as column headers.
#I then looped through output and store colon delimited info in separate variables.
#I then formatted the output to make it look neat.

#!/bin/bash


MEMORY=$(ps -eo pid,%mem,command --sort=-%mem | head -n 11 | tail -n +2 | sort -k2 -n | awk '{print $1 ":" $3}')

printf "%-10s%-10s%s\n" "PID" "COMMAND" 
for i in $MEMORY
do
	PID=$(echo $i | cut -d: -f1)
	COMMAND=$(echo $i | cut -d: -f2)
	printf "%-10s%-10s%s\n" "$PID" "$COMMAND"
done
