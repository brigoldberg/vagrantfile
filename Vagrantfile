# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    config.vm.box = "centos/7"

    config.vm.define "poodle" do |machine|
        machine.vm.hostname = "poodle"
        machine.vm.network "private_network", ip: "192.168.33.10"
        machine.vm.network "forwarded_port", guest: 80, host: 8080
        machine.vm.provider "virtualbox" do |vb|
            vb.memory = 1024
            vb.cpus = 1
        end
        machine.vm.provision :shell, :path => "bootstrap.sh"
    end
end
