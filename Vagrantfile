# Create a minimal Ubuntu box
Vagrant.require_version ">= 1.8.3"
Vagrant.configure(2) do |config|


    # Configure the base box
    config.vm.define "ubuntu" do |ubuntu|
        #ubuntu.vm.box = "ubuntu/xenial64"
        ubuntu.vm.box = "ubuntu/trusty64"
        ubuntu.vm.network :forwarded_port, guest: 80, host: 8080
        ubuntu.vm.synced_folder "elastic-stack/", "/elastic-stack/", type: "rsync"
    end


    # Configure the VirtualBox parameters
    config.vm.provider "virtualbox" do |vb|
        vb.name = "elastic-stack"
        vb.customize [ "modifyvm", :id, "--memory", "2560" ]
    end


    # Configure the box with Ansible
    config.vm.provision "ansible_local" do |ansible|
        ansible.playbook = "/elastic-stack/0_install.yml"
    end


end
