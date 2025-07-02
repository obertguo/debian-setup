# Debian-Setup
A collection of Ansible and bash scripts for setting up a personal Debian environment from scratch.
## Overview
1. Download/clone this repository onto your Debian environment. 
2. Execute `bash init.sh` to run first-time initialization, which is mostly intended for a "minimal" Debian install (i.e., no DE selected during a first time Debian install). This will install and setup a Gnome DE and add your user to the sudoers group. This allows sudo commands to be run then next time you re-login in as your user.
3. Configure `host_vars/localhost-CHANGEME.yml` as needed (note: you will need to include github credentials), and rename it to `host_vars/localhost.yml`. Note that the re-named localhost.yml file is excluded from git as part of this repository's .gitignore file.
4. Run `bash pipeline.sh` to install Python and setup an Ansible virtual environment if it has not been set up yet. If a playbook name is passed in as an argument to the pipeline script, then the corresponding Ansible playbook is run. Otherwise, by default, the playbooks listed in the pipeline script `PLAYBOOKS_TO_RUN` array are run in order, and is intended to provide everything needed for a full setup.

## To-Dos
- Consolidate setup scripts into one master setup script
- Add maintanence scripts (e.g., package updates, archiving/backups, regular config syncing, add some cron jobs, etc)
- Look into Ansible vault for better credential management
- Utilize Ansible tags to run certain playbooks
- Run Ansible tasks in parallel and run playbooks in parallel through bash
- Add handlers, rescues/always, etc, for cleanup and redundancy
