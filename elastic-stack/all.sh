#!/bin/bash

# Run all playbooks at once
ansible-playbook /elastic-stack/1_configure-elasticsearch.yml
ansible-playbook /elastic-stack/2_configure-kibana.yml
ansible-playbook /elastic-stack/3_configure-logstash.yml
ansible-playbook /elastic-stack/4_configure-filebeat.yml
ansible-playbook /elastic-stack/4_configure-topbeat.yml
ansible-playbook /elastic-stack/4_configure-packetbeat.yml
ansible-playbook /elastic-stack/5_configure-dashboards.yml
ansible-playbook /elastic-stack/6_add-plugins.yml
