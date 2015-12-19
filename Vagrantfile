# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "centos-6.7"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "4096"
    vb.gui = true
    vb.cpus = 4
  end

  config.vm.provision "shell", path: 'provision.sh', privileged: false
  config.vm.provision "shell", path: 'build.sh', privileged: false
end
