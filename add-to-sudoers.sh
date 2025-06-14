#!/bin/sh

# Adds a user to sudoers. 
# Needs to be run as a root user. (E.g., "su -").

USERNAME=$1
if [ -z "$USERNAME" ]
then 
	echo "Specify a username to add to sudoers"
	exit 1
fi

usermod -aG sudo "$USERNAME"
if [ $? -ne 0 ] 
then 
	echo "Failed to add ${USERNAME} to sudoers"
else 
	echo "Succesfully added ${USERNAME} to sudoers"
	echo "Rebooting in 5s for changes to be applied" 
	sleep 5 && reboot
fi