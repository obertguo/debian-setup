#!/bin/sh

# This script installs and enables the Gnome DE
# and is intended to be used after a "minimal" installation
# of Debian (i.e., no selected DE through the Debian installer)
# Pretty much gets a Gnome DE up and running.

USERNAME=$1

install_gnome() {
    apt-get -y update && apt-get -y upgrade
    apt-get install gdm3 gnome-shell
    enable gui login
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
    else 
        echo "Successfully added ${USERNAME} to sudoers"
    fi
}

run_init() {
    if [ "$(whoami)" != 'root' ]
    then 
        echo "This init script needs to be run as the root user. (Enter 'su - ' in the terminal)"
        exit 1
    fi

    if [ -z "$USERNAME" ]
    then 
        echo "Specify your non-root account's username"
        exit 1
    fi

    install_gnome
    install_core_packages
    add_to_sudoers
    echo "Rebooting in 5s for changes to be applied"
    sleep 5 && reboot
}