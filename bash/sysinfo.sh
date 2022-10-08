#!/bin/bash
#improved sysinfo script.

#gathering data for the script

FQDN=$(hostname --fqdn) #gathers the FQDN of the machine
distroVersion=$(hostnamectl | grep -w "Operating System:" | awk '{print $3, $4, $5}') #Gathers the Distro Name and Version
network=$(hostname -I) #Gathers the IP address
freeSpace=$(df -h | grep -w '/' | awk '{print $4}') #Displays the amount of freespace available

cat <<EOF
My Computer System Info

=======================

FQDN:  $FQDN
Operating System and Version: $distroVersion
IP Address: $network
Root Filesystem Free Space: $freeSpace

=======================
EOF
