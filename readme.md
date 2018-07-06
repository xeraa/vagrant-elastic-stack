# Elastic Stack in a Box

This repository will install the [Elastic Stack](https://www.elastic.co/products) (Elasticsearch, Logstash, Kibana, and Beats) and optionally X-Pack. You can either start from scratch and configure everything with [Vagrant and Ansible](#vagrant-and-ansible) or you can [download the final OVA image](#ova-image).



## Features

* Filebeat `system`, `auditd`, `logstash`, `mongodb`, `nginx`, `osquery`, and `redis` modules
* Filebeat collecting Kibana JSON logs from `/var/log/kibana/kibana.log`
* Auditbeat `file_integrity` module on `/home/vagrant/` directory and `auditd` module
* Heartbeat pinging nginx every 10s
* Metricbeat `system`, `docker`, `elasticsearch`, `kibana`, `logstash`, `mongodb`, `nginx` and `redis` modules
* Packetbeat sending its data via Redis + Logstash, monitoring flows, ICMP, DNS, HTTP (nginx and Kibana), Redis, and MongoDB (generate traffic with `$ mongo /elastic-stack/mongodb.js`)
* The pattern for nginx is already prepared in */opt/logstash/patterns/* and you can collect */var/log/nginx/access.log* with Filebeat and add a filter in Logstash with the pattern as an exercise

![](screenshot.png)


## Vagrant and Ansible

Do a simple `vagrant up` by using [Vagrant](https://www.vagrantup.com)'s [Ansible provisioner](https://www.vagrantup.com/docs/provisioning/ansible.html). All you need is a working [Vagrant installation](https://www.vagrantup.com/docs/installation/) (2.1.2+ but the latest version is always recommended), a [provider](https://www.vagrantup.com/docs/providers/) (tested with the latest [VirtualBox](https://www.virtualbox.org) version), and 3GB of RAM.

With the [Ansible playbooks](https://docs.ansible.com/ansible/playbooks.html) in the */elastic-stack/* folder you can configure the whole system step by step. Just run them in the given order inside the Vagrant box:

```sh
> vagrant ssh
$ ansible-playbook /elastic-stack/1_configure-elasticsearch.yml
$ ansible-playbook /elastic-stack/2_configure-kibana.yml
$ ansible-playbook /elastic-stack/3_configure-logstash.yml
$ ansible-playbook /elastic-stack/4_configure-auditbeat.yml
$ ansible-playbook /elastic-stack/4_configure-filebeat.yml
$ ansible-playbook /elastic-stack/4_configure-heartbeat.yml
$ ansible-playbook /elastic-stack/4_configure-metricbeat.yml
$ ansible-playbook /elastic-stack/4_configure-packetbeat.yml
$ ansible-playbook /elastic-stack/5_trial-xpack.yml
```

Or if you are in a hurry, run all playbooks with `$ /elastic-stack/all.sh` at once.



## OVA Image

If Vagrant and Ansible sound too complicated, there is also the final result: An OVA image, which you can import directly into [VirtualBox](https://www.virtualbox.org):

* Download the image from [https://s3.eu-central-1.amazonaws.com/xeraa/public/elastic-stack.ova](https://s3.eu-central-1.amazonaws.com/xeraa/public/elastic-stack.ova).
* Load the OVA file into VirtualBox and make sure you have 3GB of RAM available for it: **File** -> **Import Appliance...** -> Select the file and start it
* Connect to the instance with the credentials `vagrant` and `vagrant` in the VirtualBox window.
* Or use SSH with the same credentials:
  * Windows: Use [http://www.putty.org](http://www.putty.org) and connect to `vagrant@127.0.0.1` on port 2222.
  * Mac and Linux: `$ ssh vagrant@127.0.0.1 -p 2222 -o PreferredAuthentications=password`

It might happen that Beats services don't start properly because Elasticsearch is not available (yet).
If you don't see any data coming in your Kibana dashboards, you can check that Elasticsearch is running and then start the services manually:

```sh
# Check Elasticsearch is running
curl localhost:9200

# Start all services
sudo service auditbeat start
sudo service filebeat start
sudo service heartbeat-elastic start
sudo service metricbeat start
sudo service packetbeat start
```


## Kibana

Access Kibana at [http://localhost:5601](http://localhost:5601).



## Test Data

You can use */opt/injector.jar* to generate test data in the `person` index. To generate 100,000 documents in batches of 1,000 run the following command:

```
$ java -jar /opt/injector.jar 100000 1000
```



## Logstash Demo

You can play around with a Logstash example by calling `$ sudo /usr/share/logstash/bin/logstash --path.settings /etc/logstash -f /elastic-stack/raffle/raffle.conf` (it can take some time) and you will find the result in the `raffle` index.
