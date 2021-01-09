#!/bin/bash


LOCATION="/etc/sysconfig/network-scripts/"
DEVICE=$1
IP=$2
NEW_IP=$3
FILE=ifcfg-${DEVICE}

## Making sure that all variables are not empty
if [[ -z "$DEVICE" || -z "$IP" || -z "$NEW_IP" ]]
	then 
	echo "Usage: ${0} network_device_name current_IP new_IP "
	exit 1
fi

### Copying this to a temp file for scp
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

#Function-----------------------------------------------

scp_access () {

local logins="sshpass -p ${PASSWORD}"
$logins $1
if [ $? != 0 ]; then
	echo "SCP not complete"
	exit 1
else
	echo "SCP is now complete"
fi
}

ssh_access () {
local logins="sshpass -p ${PASSWORD} ssh -o StrictHostKeyChecking=no root@${IP}"
$logins $1
}


#Main----------------------------------------------------

scp_access "scp /tmp/$FILE root@${IP}:${LOCATION}/rurufhfhfh"
ssh_access "systemctl restart network"&

exit 0

