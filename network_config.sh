#!/bin/bash

# I have created this script to update IP's on new servers i build, destroy and rebuild again. It requires 3 parameters such as device name, current and new IP. 
#This will save me alot of time when creating various projects in my homelab.
# I will probably update this script so that I can run other commands such as yum update using the ssh_access () function.

LOCATION="/etc/sysconfig/network-scripts/"
DEVICE=$1
IP=$2
NEW_IP=$3
FILE=ifcfg-${DEVICE}

## Making sure that all variables are not empty
if [[ -z "$DEVICE" || -z "$IP" || -z "$NEW_IP" ]]
	then 
	echo "Usage: ${0} <network_device_name> <current_IP> <new_IP>"
	exit 1
fi

# Copying this to a temp file for scp
cat <<EOF > /tmp/${FILE}
DEVICE=${DEVICE}
BOOTPROTO=static
ONBOOT=yes
IPADDR=${NEW_IP}
NETMASK=255.255.255.0
GATEWAY=192.168.1.1
DNS1=192.168.1.1
EOF

echo "Enter ssh password:"
read -s PASSWORD

SSH="sshpass -p ${PASSWORD} ssh -o StrictHostKeyChecking=no root@${IP}"


#Function-----------------------------------------------

scp_access () {

local LOGINS="sshpass -p ${PASSWORD}"
$LOGINS $1
SUCCESS=$(echo $?)
GREPPING=$($SSH grep -ow ${NEW_IP} ${LOCATION}${FILE})

# Checking to see if the file has been copied and IP has been updated 
if [[ "$SUCCESS" == 0 && "$GREPPING" == "$NEW_IP" ]]
then
	echo "SCP is complete"
else
	echo "SCP has failed"
	exit 1
fi
}

ssh_access () {
$SSH $1
}


#Main----------------------------------------------------

scp_access "scp /tmp/$FILE root@${IP}:${LOCATION}"
ssh_access "systemctl restart network"&

exit 0
