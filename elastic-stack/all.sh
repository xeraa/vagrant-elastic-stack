#!/bin/bash

# Run all playbooks at once
ansible-playbook /elastic-stack/1_configure-elasticsearch.yml
ansible-playbook /elastic-stack/2_configure-kibana.yml
ansible-playbook /elastic-stack/3_configure-logstash.yml
ansible-playbook /elastic-stack/4_configure-auditbeat.yml
ansible-playbook /elastic-stack/4_configure-filebeat.yml
ansible-playbook /elastic-stack/4_configure-heartbeat.yml
ansible-playbook /elastic-stack/4_configure-metricbeat.yml
ansible-playbook /elastic-stack/4_configure-packetbeat.yml
