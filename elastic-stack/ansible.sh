#!/bin/bash -eux

# set the session to be noninteractive
export DEBIAN_FRONTEND="noninteractive"

# Install Ansible repository.
apt -y install software-properties-common
apt-add-repository ppa:ansible/ansible

# Install Ansible.
apt -y update
apt -y install ansible

mkdir /elastic-stack/
chmod 0777 /elastic-stack