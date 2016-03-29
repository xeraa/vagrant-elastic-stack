# Elastic Stack in Vagrant

This repository will install the [Elastic Stack](https://www.elastic.co/products) (Elasticsearch, Logstash, Beats, and Kibana) with a simple `vagrant up` by using [Vagrant](https://www.vagrantup.com)'s [Ansible provisioner](https://www.vagrantup.com/docs/provisioning/ansible.html). All you need is a working [Vagrant installation](https://www.vagrantup.com/docs/installation/).

In addition, with the [Ansible playbooks](https://docs.ansible.com/ansible/playbooks.html) in the *elastic-stack/* folder you can configure the whole system step by step. Just run them in the given order inside the Vagrant box:

```
> vagrant ssh
$ playbook elastic-stack/1_configure-elasticsearch.yml
$ playbook elastic-stack/2_configure-kibana.yml
$
```



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
