#!/bin/bash

#@barcrange

# input for ip,username,key
read -p "Enter the IP address: " ip_address
read -p "Enter the username: " username
read -p "Enter the path to the SSH key file: " key_file

# Execute the SSH commands to make the changes

ssh -i $key_file $username@$ip_address "sudo passwd $username; \

sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config; \

sudo service sshd restart"

# Prompt the user for their new password
read -s -p "Enter your new password for SSH: " password

# Allow the user to SSH back in using the new password
ssh -i $key_file $username@$ip_address << EOF
echo $password | sudo -S true
EOF

if [ $? -eq 0 ]; then
    echo "Password verified. You can now SSH back in."
    ssh $username@$ip_address
else
    echo "Failed to verify password."
fi
