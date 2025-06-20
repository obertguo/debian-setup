# Debian-Setup
A collection of Ansible and bash scripts for setting up a personal Debian environment from scratch.
## Overview
1. Download/clone this repository onto your Debian environment. 
2. Execute `su -` to login as su, and run `add-to-sudoers.sh YOUR_USERNAME` to add YOUR_USERNAME to the sudoers group. This allows sudo commands to be run when logged in as YOUR_USERNAME.
3. Run `setup.sh` to install Python and setup an Ansible virtual environment.
4. Configure `host_vars/localhost.yml` if needed, and configure `.env` with user related configuration/credentials.
5. Run `pipeline.sh` with bash to begin running Ansible playbooks. The playbooks are executed in order as defined in the `PLAYBOOKS_TO_RUN` array in the pipeline script.

# To-Dos
- Consolidate setup scripts into one master setup script
- Add maintanence scripts (e.g., package updates, archiving/backups, regular config syncing, add some cron jobs, etc)
- Look into Ansible vault for better credential management
- Utilize Ansible tags to run certain playbooks
- Run Ansible tasks in parallel and run playbooks in parallel through bash
- Add handlers, rescues/always, etc, for cleanup and redundancy
