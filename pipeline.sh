#!/bin/bash
PLAYBOOKS_TO_RUN=("apt.yml" "user.yml")
PLAYBOOKS_TO_RUN=("test-playbook.yml")

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
  # Load user credentials into current shell session and copy over to user's home directory
  . ./.env  && cp ./.env ~/.env || exit 1

  SUDO_PASSWORD=""
  read -s -p "Enter sudo password to allow privileged playbook execution: " SUDO_PASSWORD

  for PLAYBOOK in ${PLAYBOOKS_TO_RUN[@]}; do
    call_playbook $PLAYBOOK $SUDO_PASSWORD
  done
}

run_pipeline