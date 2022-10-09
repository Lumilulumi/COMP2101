#!/bin/bash
#Checks to see if lxd is already installed on host machine. IF not installs it.
cat <<EOF1
===============WebServer Install=============================
This will install an Apache2 Web Server in a container.
It might need your password to install. 
LXD, Ubuntu Server 20.04, and Apache2 will be download.
This might take some time depending on network speed.
There will be some user input required!
=============================================================
EOF1

#Looks for lxd installed. Will Install if not installed. 
which lxd >/dev/null
if [ $? -ne 0 ]; then
	echo "Installing lxd - you might to enter your password to install it"
	sudo snap install lxd
	if [ $? -ne 0 ]; then
		echo "Failed to install lxd software which is required"
		exit 1
	fi
fi

#Looks at IP addr for network interface lxdbr0. If not active, will run the installer for it. 
ip addr | grep -w lxdbr0 >/dev/null
if [ $? -ne 0 ]; then
	echo "Running lxd init --auto to install interface"
	lxd init --auto
	if [ $? -ne 0 ]; then
		echo "failed to create interface"
		exit 1
	fi
fi

#Looks at the container list to see if there is one called COMP2101-F22. If not creates one
#and downloads the Ubuntu server 20.04 image. 
lxc list | grep -w "COMP2101-F22" >/dev/null
	if [ $? -ne 0 ]; then
	echo "Creating container COMP2101-F22. This will download ubuntu server 20.04. Might take some time. Go grab a coffee"
	lxc launch ubuntu:20.04 COMP2101-F22
	sleep 5
	if [ $? -ne 0 ]; then
		echo "Failed to create container COMP2101-F22"
		exit 1
	fi
fi

#Checks to see if the container IP is in the /etc/hosts file. If not it will add it or update it.
export hostIP; hostIP=$(grep -w "COMP2101-F22" /etc/hosts | awk '{print $1}')
export conIP; conIP=$(lxc exec COMP2101-F22 -- ip addr show eth0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
if [[ "$conIP" != "$hostIP" ]]; then
	echo "adding contianer IP to /etc/hosts"
	sudo -- sh -c -e "echo '$conIP  COMP2101-F22' >> /etc/hosts"
	if [ $? -ne 0 ]; then
		echo "Failed to add IP to /etc/hosts"
		exit 1
	fi
else 	
	echo "IP already in /etc/hosts"
fi

#This will install Apache2 into the container. output hidden on the screen. Will auto yes any questions. 
which lxc exec COMP2101-F22 -- which apache2 >/dev/null
if [ $? -ne 0 ]; then
	echo "installing apache2 in container COMP2101-F22"
	lxc exec COMP2101-F22 -- apt-get -y install apache2 &> /dev/null
	echo "Apache2 installed"
	if [ $? -ne 0 ]; then
		echo "Error installing apache2 in container"
		exit 1
	fi
fi

#checks to see if curl is installed on host machine. Will install it if missing. Will auto yes any questions
which curl >/dev/null
if [ $? -ne  0 ]; then
	echo "You don't have Curl installed. Installing it now."
	sudo apt-get -y install curl &> /dev/null
	echo "curl has been installed"
	if [ $? -ne 0 ]; then
		echo "Error Installing Curl"
		exit 1
	fi
fi

#Will curl the webserver on the container to see if it can get a connection. 
curl http://COMP2101-F22 >/dev/null	
if [ $? = 0 ]; then
		echo "Able to connect to WebServer. Mission Succesful. Go have a cookie with that coffee!"
	else
		echo	"unable to connect to WebServer!!!!!. Please check network settings." 
		exit 1
fi	

