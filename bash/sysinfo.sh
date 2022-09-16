#!/bin/bash

# Displays the Fully-Qualified domain name
echo 'FQDN:' $(hostname --fqdn)

#Displays the Operating System name and Version
echo 'Host Information:' 
cat <<EOF 
$(hostnamectl)
EOF

#Displays the IP Addresses without any 127. ones
echo 'IP addresses:'
cat <<EOF
$grep $(hostname -I)
EOF

#displays spave available in the only Root Filesystem
echo 'Rootfile system status:'
cat <<EOF
$(df -h /dev/sda3)
EOF
