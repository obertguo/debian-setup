#!/bin/bash

# For now, we can either run a single playbook by passing in the playbook 
# by passing in the playbook name, or fallback to a list of playbooks to run if 
# a playbook is not specified
PLAYBOOKS_TO_RUN=$1

if [ -z "$1" ]; then
  PLAYBOOKS_TO_RUN=("apt.yml" "user.yml" "programs.yml" "gnome.yml")
else
  PLAYBOOKS_TO_RUN=$(ls ./playbooks | grep -i "$PLAYBOOKS_TO_RUN" | head -n 1)
  stat "./playbooks/$PLAYBOOKS_TO_RUN" 1> /dev/null || exit 1
fi

call_playbook() {
  PLAYBOOK=$1
  SUDO_PASSWORD=$2

  cp "./playbooks/${PLAYBOOK}" .
  ansible-playbook -v -i ./inventory/inventory.ini $PLAYBOOK --extra-vars ansible_sudo_pass=${SUDO_PASSWORD}
  if [ $? -ne 0 ]
  then
    echo "Failed to run ${PLAYBOOK}"
    rm $PLAYBOOK
    if [ -d ./tmp ]; then rm -rf ./tmp; fi
    exit 1
  fi
  
  echo "Succesfully ran ${PLAYBOOK}"
  if [ -d ./tmp ]; then rm -rf ./tmp; fi
  rm $PLAYBOOK 
}

run_pipeline() {
  # Load Ansible
  . ./ansible-venv/bin/activate || exit 1

  # Load .env into current shell session (required to load in sensitive variables)
  . ./.env || exit 1;
  
  # Copy .env over to user's home directory if it does not exist.
  # This is to prevent overwriting since we will dynamically add PATH variables to the .env file later
  if [ ! -f ~/.env ]; then cp ./.env ~/.env; fi

  SUDO_PASSWORD=""
  read -s -p "Enter sudo password to allow privileged playbook execution: " SUDO_PASSWORD

  for PLAYBOOK in ${PLAYBOOKS_TO_RUN[@]}; do
    call_playbook $PLAYBOOK $SUDO_PASSWORD
  done
}

run_pipeline
