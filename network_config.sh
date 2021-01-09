#!/bin/bash


LOCATION="/etc/sysconfig/network-scripts/"
DEVICE=$1
IP=$2
NEW_IP=$3
FILE=ifcfg-${DEVICE}

if [[ -z "$DEVICE" || -z "$IP" || -z "$NEW_IP" ]]
	then 
	echo "Usage: ${0} network_device_name current_IP new_IP "
	exit 1
fi

cat <<EOF > /tmp/${FILE}
DEVICE=${DEVICE}
BOOTPROTO=static
ONBOOT=yes
IPADDR=${NEW_IP}
NETMASK=255.255.255.0
GATEWAY=192.168.1.1
DNS1=192.168.1.1
EOF

echo "Enter something goddammit:"
read -s PASSWORD

logins="sshpass -p ${PASSWORD} ssh -o StrictHostKeyChecking=no root@${IP}"


#SCP the file to the destination server
sshpass -p $PASSWORD scp /tmp/$FILE root@${IP}:${LOCATION} 

$logins systemctl restart network

exit 0

