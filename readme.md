# Elastic Stack in a Box

This repository will install the [Elastic Stack](https://www.elastic.co/products) (Elasticsearch, Logstash, Kibana, and Beats) and optionally X-Pack. You can either start from scratch and configure everything with [Vagrant and Ansible](#vagrant-and-ansible) or you can [download the final OVA image](#ova-image).



## Features

* ~~Filebeat collecting Syslog and Kibana's JSON log, Logstash parsing the Syslog file~~
* Filebeat modules for nginx and system
* Heartbeat pinging nginx
* Metricbeat collecting system metrics plus nginx, MongoDB, and Redis
* Packetbeat sending its data via Redis + Logstash, monitoring flows, ICMP, DNS, HTTP (nginx and Kibana), Redis, and MongoDB (generate traffic with `$ mongo /elastic-stack/mongodb.js`)
* On 64bit instances Redis in a container, monitored by Metricbeat's Docker module, and Filebeat collects the *json-file* log
* Dashboards for Filebeat, Heartbeat, Metricbeat, and Packetbeat
* X-Pack with security and monitoring for Elasticsearch, Logstash, and Kibana
* The pattern for nginx is already prepared in */opt/logstash/patterns/* and you can collect */var/log/nginx/access.log* with Filebeat and add a filter in Logstash with the pattern as an exercise

![](screenshot.png)



## Vagrant and Ansible

Do a simple `vagrant up` by using [Vagrant](https://www.vagrantup.com)'s [Ansible provisioner](https://www.vagrantup.com/docs/provisioning/ansible.html). All you need is a working [Vagrant installation](https://www.vagrantup.com/docs/installation/) (1.8.6+ but the latest version is always recommended), a [provider](https://www.vagrantup.com/docs/providers/) (tested with the latest [VirtualBox](https://www.virtualbox.org) version), and 2.5GB of RAM.

With the [Ansible playbooks](https://docs.ansible.com/ansible/playbooks.html) in the */elastic-stack/* folder you can configure the whole system step by step. Just run them in the given order inside the Vagrant box:

```
> vagrant ssh
$ ansible-playbook /elastic-stack/1_configure-elasticsearch.yml
$ ansible-playbook /elastic-stack/2_configure-kibana.yml
$ ansible-playbook /elastic-stack/3_configure-logstash.yml
$ ansible-playbook /elastic-stack/4_configure-filebeat.yml
$ ansible-playbook /elastic-stack/4_configure-heartbeat.yml
$ ansible-playbook /elastic-stack/4_configure-metricbeat.yml
$ ansible-playbook /elastic-stack/4_configure-packetbeat.yml
$ ansible-playbook /elastic-stack/5_configure-dashboards.yml
$ ansible-playbook /elastic-stack/6_add-xpack.yml
```

Or if you are in a hurry, run all playbooks with `$ /elastic-stack/all.sh` at once.



## OVA Image

If Vagrant and Ansible sound too complicated, there is also the final result: An OVA image, which you can import directly into [VirtualBox](https://www.virtualbox.org):

* Download the image from [https://s3.eu-central-1.amazonaws.com/xeraa/public/elastic-stack.ova](https://s3.eu-central-1.amazonaws.com/xeraa/public/elastic-stack.ova).
* Load the OVA file into VirtualBox and make sure you have 2.5GB of RAM available for it: File -> Import Appliance... -> Select the file and start it
* Connect to the instance with the credentials `vagrant` and `vagrant` in the VirtualBox window.
* Or use SSH with the same credentials:
  * Windows: Use [http://www.putty.org](http://www.putty.org) and connect to `vagrant@127.0.0.1` on port 2222.
  * Mac and Linux: `$ ssh vagrant@127.0.0.1 -p 2222 -o PreferredAuthentications=password`
  
  
  
## Packer AWS AMI

If you want to deploy this to Amazon, you can use Packer to build the AMI image, using the latest official Ubuntu 16.04 Xenial LTS release from Canonical. You will need:
* Packer https://www.packer.io/downloads.html
* AWS CLI http://docs.aws.amazon.com/cli/latest/userguide/installing.html
* AWS IAM Role to deploy EC2 instances
* jq https://stedolan.github.io/jq/

```shell
./build_packer.sh
```

The example script is configured to the "us-east-1" region, it will use your locally installed AWS CLI to find the first / default VPC ID, the first subnet within that VPC, build the AMI, save the results to manifest.json file, and use jq to extract the AMI id.
You can easily integrate this into a Jenkins pipeline to automate the build of your ELK stack, and optionally use Terraform to deploy the AMI.



## Kibana

Access Kibana at [http://localhost:5601](http://localhost:5601).

If you have added X-Pack (by running `$ ansible-playbook /elastic-stack/6_add-xpack.yml` or `$ /elastic-stack/all.sh` or used the final OVA image) you will need to login into Kibana with the default credentials — username `elastic` and password `changeme`.

The Beats are configured with the same credentials automatically.



## Test Data

You can use */opt/injector.jar* to generate test data in the `person` index. To generate 100,000 documents in batches of 1,000 run the following command:

```
$ java -jar /opt/injector.jar 100000 1000
```



## Logstash Demo

You can play around with a Logstash example by calling `$ sudo /usr/share/logstash/bin/logstash --path.settings /etc/logstash -f /elastic-stack/raffle/raffle.conf` (it can take some time) and you will find the result in the `raffle` index.



## Release Notes

Elastic
- https://www.elastic.co/downloads/past-releases

Elasticsearch
- https://github.com/elastic/elasticsearch/releases
- https://www.elastic.co/guide/en/elasticsearch/reference/current/es-release-notes.html

Logstash
- https://github.com/elastic/logstash/releases
- https://www.elastic.co/guide/en/logstash/current/releasenotes.html

Kibana
- https://github.com/elastic/kibana/releases
- https://www.elastic.co/guide/en/kibana/current/release-notes.html

Beats
- https://github.com/elastic/beats/releases

X-Pack
- https://www.elastic.co/guide/en/x-pack/current/xpack-introduction.html
- https://www.elastic.co/guide/en/x-pack/current/xpack-change-list.html



## Log files
```shell

# filebeat
/var/log/filebeat/filebeat

# metricbeat
/var/log/metricbeat/metricbeat

# heartbeat
/var/log/heartbeat/heartbeat

# logstash
/var/log/logstash/logstash-plain.log
/var/log/logstash/logstash.stdout
/var/log/logstash/logstash.log

# elasticsearch
/var/log/elasticsearch/elasticsearch.log
/var/log/elasticsearch/elasticsearch.log.*
/var/log/elasticsearch/elasticsearch_deprecation.log
/var/log/elasticsearch/elasticsearch_index_search_slowlog.log
/var/log/elasticsearch/elasticsearch_index_indexing_slowlog.log.log

# kibana
/var/log/kibana.log
/var/log/kibana/kibana.stderr
/var/log/kibana/kibana.stdout
```



## Application folders
```shell

# filebeat
/etc/filebeat
/usr/share/filebeat

# metricbeat
/etc/metricbeat
/usr/share/metricbeat

# heartbeat
/etc/heartbeat
/usr/share/heartbeat

# logstash
/etc/logstash
/usr/share/logstash

# elasticsearch
/etc/elasticsearch/
/usr/share/elasticsearch/

# kibana
/etc/kibana
/usr/share/kibana
/opt/kibana
```