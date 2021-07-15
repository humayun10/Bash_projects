##This script is to run a single command to a list of servers in hosts.txt file. It will read the hostname from that file 
#and run the command in a function

#!/bin/bash
file=$(cat hosts.txt)
echo "Enter ssh password"
read -s PASSWORD

SSH="sshpass -p ${PASSWORD} ssh -o StrictHostKeyChecking=no root@"

run () {
for i in $file; do
	echo -e "this is server: ${i}"
	echo -------------------------
	$SSH${i} $1
	echo ""
done

}

run "ls -l /home"
