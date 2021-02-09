#!/bin/bash

#####################################################################################################################################################
#After initial setup using pxe booting, this scritp is to make a few updates and changes. This will make it easier for me to build multiple servers #
#efficiently in a homelab test environment. I will probably update this script as I go along.                                                       #
#####################################################################################################################################################


echo "Enter ssh password:"
read -s PASSWORD

KEY=$(cat /home/boss/.ssh/boss-key.pub)
IP="192.168.1.31"
SSH="sshpass -p ${PASSWORD} ssh -o StrictHostKeyChecking=no root@${IP}"
USER="boss"
HOME="/home/${USER}"

read -p "Is the IP address: ${IP} correct? " REPLY 
case $REPLY in 
	[Yy]|[Yy][Es][Ss])
	echo "Let's proceed"
	;;
	[Nn]|[Nn][Oo])
	echo "Exiting, please enter correct IP and try again"
	exit 1
	;;
esac


#Function-----------------------------------------------

ssh_access () {
$SSH $1
}


#Main----------------------------------------------------

#Adding user and updating sudoers
ssh_access "useradd ${USER}"
ssh_access "touch /etc/sudoers.d/${USER} && chmod 600 /etc/sudoers.d/${USER} && echo '%${USER} ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/${USER}"

#Adding public key for user
ssh_access "mkdir -p /home/${USER}/.ssh; chmod 700 /home/${USER}/.ssh; chown -R boss:boss ${HOME}/.ssh"
ssh_access "touch /home/boss/.ssh/authorized_keys; echo '$KEY' >> /home/boss/.ssh/authorized_keys"

##Changing hostname. Last part of the hostname will include the last OCTET of the ip address
HOST=$(ssh_access "cat /etc/hostname")
LAST_OCTET=$(ssh_access "ip addr | grep -i 'inet 192' | awk '{print $2}'| cut -d '.' -f 4 | cut -d '/' -f 1")
read -p "Enter the name of server: " SERVERNAME
ssh_access "sed -i 's/${HOST}/${SERVERNAME}-${LAST_OCTET}/' /etc/hostname"


#Configuring Repos
ssh_access "mv /etc/yum.repos.d/* /home/boss"
cat <<EOF > /tmp/hdot.repo
[FTPLocal]
name=CentOS-7.9 - Main
baseurl=ftp://192.168.1.248/pub
enabled=1
gpgcheck=0

[FTPLocalEpel]
name=Centos-7.9 - Epel
baseurl=ftp://192.168.1.248/epel
enabled=1
gpgcheck=0
EOF

#SCP the repo file
LOGINS="sshpass -p ${PASSWORD}"
$LOGINS scp /tmp/hdot.repo root@${IP}:/etc/yum.repos.d/

#SSH config update
ssh_access "sed -i 's/^#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config | grep 'PubkeyAuthentication'"
ssh_access "sed -i 's/^PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config; systemctl restart sshd"

