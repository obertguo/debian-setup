#!/bin/bash
set -oe pipefail

# This script installs and enables a Gnome or KDE Plasma DE
# and is intended to be used after a "minimal" installation
# of Debian (i.e., no selected DE through the Debian installer)
# Pretty much gets a DE up and running.

USERNAME=""
DESKTOP_ENVIRONMENT=""

install_gnome() {
    apt-get -y update && apt-get -y upgrade
    apt-get install gdm3 gnome-shell
    # The gnome-shell does not include any applications, so we'll need these later
    apt-get install gnome-terminal gnome-text-editor
    # Enable GUI login
    systemctl enable gdm && systemctl set-default graphical.target
}

install_kde() {
    apt-get -y update && apt-get -y upgrade
    apt-get install kde-plasma-desktop
    # Enable GUI login
    systemctl enable sddm && systemctl set-default graphical.target
}

install_core_packages() {
    apt-get -y update && apt-get -y upgrade
    apt-get install sudo git
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

    read -p "Enter what DE you would like. Valid choices are 'gnome' or 'kde' " DESKTOP_ENVIRONMENT
    if [ "$DESKTOP_ENVIRONMENT" != "kde" ] && [ "$DESKTOP_ENVIRONMENT" != "gnome" ]; then
        echo "Unknown DE. Rerun the setup again." && exit 1
    fi

    install_core_packages && add_to_sudoers
    
    if [ "$DESKTOP_ENVIRONMENT" == "kde" ]; then
        install_kde
    elif [ "$DESKTOP_ENVIRONMENT" == "gnome" ]; then
        install_gnome
    fi

    echo "Rebooting in 5s for changes to be applied"
    sleep 5 && reboot
}

if [ "$(whoami)" != 'root' ]
then
    USERNAME=$(whoami)
    echo "This init script needs to be run as a root user:"
    su - root -c "bash $(pwd)/init.sh"
else
    run_init
fi