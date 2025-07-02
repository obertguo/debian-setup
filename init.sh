#!/bin/bash

# This script installs and enables the Gnome DE
# and is intended to be used after a "minimal" installation
# of Debian (i.e., no selected DE through the Debian installer)
# Pretty much gets a Gnome DE up and running.

USERNAME=$1

install_gnome() {
    apt-get -y update && apt-get -y upgrade
    apt-get install gdm3 gnome-shell
    # Enable GUI login
    systemctl enable gdm && systemctl set-default graphical.target
}

install_core_packages() {
    apt-get -y update && apt-get -y upgrade
    apt-get install sudo git gnome-terminal gnome-text-editor
}

add_to_sudoers() {
    usermod -aG sudo "$USERNAME"
    if [ $? -ne 0 ]
    then
        echo "Failed to add ${USERNAME} to sudoers"
        exit 1
    else 
        echo "Successfully added ${USERNAME} to sudoers"
    fi
}

run_init() {
    if [ -z "$USERNAME" ]
    then
        read -p "Enter your account's username to add to sudoers: " USERNAME
    fi

    (install_gnome && install_core_packages && add_to_sudoers) || exit 1
    echo "Rebooting in 5s for changes to be applied"
    sleep 5 && reboot
}

if [ "$(whoami)" != 'root' ]
then 
    echo "This init script needs to be run as a root user:"
    su - root -c "bash $(pwd)/init.sh"
else
    run_init
fi