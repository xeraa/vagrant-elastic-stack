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



## Kibana

Access Kibana at [http://localhost:5601](http://localhost:5601).

If you have added X-Pack (by running `$ ansible-playbook /elastic-stack/6_add-xpack.yml` or `$ /elastic-stack/all.sh` or used the final OVA image) you will need to login into Kibana with the default credentials — username `elastic` and password `changeme`.

The Beats are configured with the same credentials automatically.



## Test Data

You can use */opt/injector-5.3.jar* to generate test data in the `person` index. To generate 100,000 documents in batches of 1,000 run the following command:

```
$ java -jar /opt/injector-5.3.jar 100000 1000
```



## Logstash Demo

You can play around with a Logstash example by calling `$ sudo /usr/share/logstash/bin/logstash --path.settings /etc/logstash -f /elastic-stack/raffle/raffle.conf` (it can take some time) and you will find the result in the `raffle` index.
