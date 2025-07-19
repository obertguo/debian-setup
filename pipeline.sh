#!/bin/bash
set -oe pipefail

# It is expected that this pipeline script is run at the root of this 
# repo's folder
if [ "$(basename $(pwd))" != 'debian-setup' ]
then
  echo "Please run the pipeline script in the debian-setup directory"
  exit 1
fi

# First time pipeline initialization. Install python3
# and configure python3 venv to install Ansible
if [ ! -d ./ansible-venv ]
then
  # Recursively change owner to current user for the debian setup directory 
  # since it may have been cloned by the root user at first
  [ $USER == 'root' ] || sudo chmod -R "${USER}:${USER}" .

  sudo apt-get -y update
  sudo apt-get -y install git python3 python3-pip python3-venv

  python3 -m venv ansible-venv
  . ./ansible-venv/bin/activate
  pip3 install ansible ansible-lint
fi

# For now, we can either run a single playbook by passing in the playbook name, 
# or fallback to a list of playbooks to run if a playbook is not specified
PLAYBOOKS_TO_RUN=$1
ANSIBLE_TAGS=""

if [ -z "$PLAYBOOKS_TO_RUN" ]; then
  PLAYBOOKS_TO_RUN=("apt.yml" "user.yml" "programs.yml" "gnome.yml" "gaming.yml")
else
  shift
  # After shifting the playbook argument, the remaining arguments are to be used as tags to be passed to the playbook
  # The tags is a string array joined by a comma
  ANSIBLE_TAGS=$(printf ",%s" "$@")
  ANSIBLE_TAGS=${ANSIBLE_TAGS:1}

  PLAYBOOKS_TO_RUN=$(ls ./playbooks | grep -i "$PLAYBOOKS_TO_RUN" | head -n 1)
  stat "./playbooks/$PLAYBOOKS_TO_RUN" 1> /dev/null || exit 1
fi

call_playbook() {
  PLAYBOOK=$1
  SUDO_PASSWORD=$2
  ANSIBLE_TAGS=$3

  cp "./playbooks/${PLAYBOOK}" .

  if [ -z "$ANSIBLE_TAGS" ]; then
    ansible-playbook -v -i ./inventory/inventory.ini "$PLAYBOOK" --extra-vars ansible_sudo_pass="$SUDO_PASSWORD"
  else
    ansible-playbook -v -i ./inventory/inventory.ini "$PLAYBOOK" --extra-vars ansible_sudo_pass="$SUDO_PASSWORD" --tags="$ANSIBLE_TAGS"
  fi
  
  if [ $? -ne 0 ]
  then
    echo "Failed to run ${PLAYBOOK}"
    rm $PLAYBOOK
    if [ -d ./tmp ]; then rm -rf ./tmp; fi
    exit 1
  fi
  
  echo "Successfully ran ${PLAYBOOK}"
  if [ -d ./tmp ]; then rm -rf ./tmp; fi
  rm $PLAYBOOK 
}

run_pipeline() {
  # Load Ansible
  . ./ansible-venv/bin/activate || exit 1

  # Create a new user .env if it does not exist

  # This .env file is dynamically populated by the playbooks for things like setting user PATH variables
  if [ ! -f ~/.env ]; then touch ~/.env; fi
  . ~/.env


  SUDO_PASSWORD=""
  read -s -p "Enter sudo password to allow privileged playbook execution: " SUDO_PASSWORD

  for PLAYBOOK in ${PLAYBOOKS_TO_RUN[@]}; do
    call_playbook "$PLAYBOOK" "$SUDO_PASSWORD" "$ANSIBLE_TAGS"
    #  Reload user .env into shell session after playbook finishes
    if [ -f ~/.env ]; then . ~/.env; fi
  done
}

run_pipeline