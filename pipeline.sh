#!/bin/bash
PLAYBOOKS_TO_RUN=("apt.yml" "test.yml")

call_playbook() {
  PLAYBOOK=$1
  SUDO_PASSWORD=$2

  cp "./playbooks/${PLAYBOOK}" .
  ansible-playbook -v -i ./inventory/inventory.ini $PLAYBOOK --extra-vars ansible_sudo_pass=${SUDO_PASSWORD}
  if [ $? -ne 0 ]
  then
    echo "Failed to run ${PLAYBOOK}"
    rm $PLAYBOOK 
    exit 1
  fi
  
  echo "Succesfully ran ${PLAYBOOK}"  
  rm $PLAYBOOK 
}

run_pipeline() {
  . ./ansible-venv/bin/activate
  SUDO_PASSWORD=""
  read -s -p "Enter sudo password to allow privileged playbook execution: " SUDO_PASSWORD

  for PLAYBOOK in ${PLAYBOOKS_TO_RUN[@]}; do
    call_playbook $PLAYBOOK $SUDO_PASSWORD
  done
}

run_pipeline
