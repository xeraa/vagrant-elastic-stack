# Elastic Stack in Vagrant

This repository will install the [Elastic Stack](https://www.elastic.co/products) (Elasticsearch, Logstash, Beats, and Kibana) with a simple `vagrant up` by using [Vagrant](https://www.vagrantup.com)'s [Ansible provisioner](https://www.vagrantup.com/docs/provisioning/ansible.html). All you need is a working [Vagrant installation](https://www.vagrantup.com/docs/installation/).



## Configure the Elastic Stack with Ansible

With the [Ansible playbooks](https://docs.ansible.com/ansible/playbooks.html) in the */elastic-stack/* folder you can configure the whole system step by step. Just run them in the given order inside the Vagrant box:

```
> vagrant ssh
$ ansible-playbook /elastic-stack/1_configure-elasticsearch.yml
$ ansible-playbook /elastic-stack/2_configure-kibana.yml
$ ansible-playbook /elastic-stack/3_configure-logstash.yml
$ ansible-playbook /elastic-stack/4_configure-filebeat.yml
$ ansible-playbook /elastic-stack/5_configure-topbeat.yml
$ ansible-playbook /elastic-stack/6_configure-dashboards.yml
$ ansible-playbook /elastic-stack/7_add-plugins.yml
```

Or if you are in a hurry, run all playbooks with `/elastic-stack/all.sh` at once.



## Configure Kibana

Access Kibana at [http://localhost:8080/app/kibana](http://localhost:8080/app/kibana) with the credentials `admin` and `admin`. Add the indices `filebeat-*` and `topbeat-*` at [http://localhost:8080/app/kibana#/settings/indices/](http://localhost:8080/app/kibana#/settings/indices/).

Then you can search the logs (**Discover**), add pre-built or custom visualizations (**Visualize**), and put together a custom **Dashboard**.



## Known Issues

Vagrant <1.8.2 in combination with Ansible 2.0 fails with the following error on `vagrant up`:

```
The Ansible software could not be found! Please verify
that Ansible is correctly installed on your guest system.

If you haven't installed Ansible yet, please install Ansible
on your Vagrant basebox, or enable the automated setup with the
`install` option of this provisioner. Please check
https://docs.vagrantup.com/v2/provisioning/ansible_local.html
for more information.
```

Simply run `vagrant provision` afterwards and it will work, thanks to an ugly hack in the Vagrantfile.
