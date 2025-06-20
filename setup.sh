#!/bin/sh

sudo apt-get -y update
sudo apt-get -y install git python3 python3-pip python3-venv

python3 -m venv ansible-venv
. ./ansible-venv/bin/activate
pip3 install ansible ansible-lint
