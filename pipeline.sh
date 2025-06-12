#!/bin/bash
PLAYBOOKS_TO_RUN=("apt.yml" "test.yml")

call_playbook() {
  PLAYBOOK=$1
  cp "./playbooks/${PLAYBOOK}" .
  ansible-playbook -i ./inventory/inventory.ini $PLAYBOOK
  if [ $? -ne 0 ]
  then
    echo "Failed to run ${PLAYBOOK}"
  else 
    echo "Succesfully ran ${PLAYBOOK}"
  fi
  rm $PLAYBOOK 
}

run_pipeline() {
  . ./ansible-venv/bin/activate

  for PLAYBOOK in ${PLAYBOOKS_TO_RUN[@]}; do
    call_playbook $PLAYBOOK
  done
}

run_pipeline
