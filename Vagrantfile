# Create a minimal Ubuntu box
Vagrant.require_version ">= 1.8.1"
Vagrant.configure(2) do |config|


    # Cache downloaded packages for this box
    if Vagrant.has_plugin?("vagrant-cachier")
        config.cache.scope = :box
    end


    # Patch for Vagrant <1.8.2: https://github.com/mitchellh/vagrant/issues/6793
    # Make sure it comes before any other provisioners
    config.vm.provision "shell" do |s|
        s.inline = '[[ ! -f $1 ]] || grep -F -q "$2" $1 || sed -i "/__main__/a \\    $2" $1'
        s.args = ['/usr/bin/ansible-galaxy', "if sys.argv == ['/usr/bin/ansible-galaxy', '--help']: sys.argv.insert(1, 'info')"]
    end


    # Configure the base box
    config.vm.define "ubuntu" do |ubuntu|
        #ubuntu.vm.box = "ubuntu/xenial64"
        ubuntu.vm.box = "ubuntu/trusty64"
        ubuntu.vm.network :forwarded_port, guest: 80, host: 8080
        ubuntu.vm.synced_folder "elastic-stack/", "/elastic-stack/"#, type: "rsync"
    end


    # Configure the VirtualBox parameters
    config.vm.provider "virtualbox" do |vb|
        vb.name = "ansible-aws"
        vb.customize [ "modifyvm", :id, "--memory", "1024" ]
    end


    # Configure the box with Ansible
    config.vm.provision "ansible_local" do |ansible|
        ansible.playbook = "/elastic-stack/0_install.yml"
    end


end
