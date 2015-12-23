# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "centos-6.7"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "4096"
    vb.gui = true
    vb.cpus = 4
    vb.customize ["modifyvm", :id, "--vram", "128"]
    # vb.customize "pre-boot", [
    #   "storageattach", :id,
    #   "--storagectl", "IDE Controller",
    #   "--port", "1",
    #   "--device", "0",
    #   "--type", "dvddrive",
    #   "--medium", "emptydrive"
    # ]
  end

  config.vm.provision "shell", path: 'provision.sh', privileged: false
end
