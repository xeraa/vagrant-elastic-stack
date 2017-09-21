#!/bin/bash -eux

# set the session to be noninteractive
export DEBIAN_FRONTEND="noninteractive"

# Disable the release upgrader
sed -i.bak 's/^Prompt=.*$/Prompt=never/' /etc/update-manager/release-upgrades

# Disabling periodic apt upgrades"
echo 'APT::Periodic::Enable "0";' >> /etc/apt/apt.conf.d/10periodic

# Upgrade OS and kernel
apt -y update
apt-get -y --force-yes upgrade
apt-get -y dist-upgrade --force-yes

# Remove old packages and configs
apt-get autoremove -y
apt-get purge -y $(dpkg --list |grep '^rc' |awk '{print $2}')
