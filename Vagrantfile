# Create a minimal Ubuntu box
Vagrant.require_version ">= 2.1.2"
Vagrant.configure(2) do |config|


    # Configure the base box
    config.vm.define "ubuntu" do |ubuntu|

        # Use a 32bit version for workshops to avoid issues with 64bit virtualization
        # But use 64bit for Docker demos, since it requires a 64bit host
        # Avoid https://atlas.hashicorp.com/ubuntu/ since those are notoriously broken
        #ubuntu.vm.box = "bento/ubuntu-18.04-i386"
        ubuntu.vm.box = "bento/ubuntu-16.04"

        ubuntu.vm.hostname = "elastic-stack"

        ubuntu.vm.network :forwarded_port, guest: 5601, host: 5601

        # If you export the box switch to the second line to keep the /elastic-stack/ folder
        ubuntu.vm.synced_folder "elastic-stack/", "/elastic-stack/"
        #ubuntu.vm.synced_folder "elastic-stack/", "/elastic-stack/", type: "rsync"
    end


    # Configure the VirtualBox parameters
    config.vm.provider "virtualbox" do |vb|
        vb.name = "elastic-stack"
        vb.customize [ "modifyvm", :id, "--memory", "2560" ]
    end


    # Configure the box with Ansible
    config.vm.provision "ansible_local" do |ansible|
        ansible.compatibility_mode = "2.0"
        # Workaround as 2.6.0 is buggy with Docker
        ansible.install_mode = "pip"
        ansible.version = "2.5.5"
        ansible.playbook = "/elastic-stack/0_install.yml"
    end


end
