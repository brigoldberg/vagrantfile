# Vagrantfile

Cheat sheet and examples of my commonly used Vagrantfile stanzas.

## Networking

### Bridged Networking
```ruby    
config.vm.define "poodle" do |machine|
    machine.vm.hostname = "poodle"
    machine.vm.network "public_network", ip: "192.168.2.51"
    machine.vm.network "public_network", bridge: "en1: Wi-Fi (AirPort)"
end
```
### Private Networking
Use this for allowing machine to machine communication.  The default Vagrant networking is only host to guest.
```ruby
config.vm.define "poodle" do |machine|
    machine.vm.hostname = "poodle"
    machine.vm.network "private_network", ip: "192.168.33.51"
    machine.vm.network "forwarded_port", guest: "8080", host: "80"
    machine.vm.network "forwarded_port", guest: "3000", host: "3000"
end
```

## System Settings

### Change CPU and memory
```ruby
config.vm.define "poodle" do |machine|
    machine.vm.hostname = "poodle"
    machine.vm.provider "virtualbox" do |vb|
        vb.memory = 2048
        vb.cpus = 2
    end
end
```

### Create additional provisioning commands
Add configuration and provisioning steps to your Vagrant guest when initializing via a custom script.
```ruby
config.vm.define "poodle" do |machine|
    machine.vm.hostname = "poodle"
    machine.vm.provision :shell, :path => "bootstrap.sh"
end
```
#### Sample script
```bash
#!/usr/bin/env bash

sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
setenforce 0

yum -y install epel-release
```

## Storage
We can add disks to a Vagrant guest machine.
```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrant file with attached disks.  Use this to simulate storage machines.

Vagrant.configure("2") do |config|

    config.vm.box = "centos-bg/7"
    storageDisk01 = './storageDisk01.vdi'
    storageDisk02 = './storageDisk02.vdi'
    storageDisk03 = './storageDisk03.vdi'

    CONTROLLER = 'SCSI'

    config.vm.define "storage-1" do |machine|
        machine.vm.hostname = "storage-1"
        machine.vm.network "provate_network", ip: "192.168.33.11"
        machine.vm.provider "virtualbox" do |vb|
            unless File.exists?(storageDisk01)
                vb.customize ['createhd', '--filename', storageDisk01, '--size', 2 * 1024]
            end
            unless File.exists?(storageDisk02)
                vb.customize ['createhd', '--filename', storageDisk02, '--size', 2 * 1024]
            end
            unless File.exists?(storageDisk03)
                vb.customize ['createhd', '--filename', storageDisk03, '--size', 2 * 1024]
            end
            vb.customize ["storagectl", :id, "--name", "SCSI", "--add", "scsi", "--bootable", "off" ]
            vb.customize ['storageattach', :id, '--storagectl', CONTROLLER, '--port', 0, '--device', 0, '--type', 'hdd', '--medium', storageDisk01]
            vb.customize ['storageattach', :id, '--storagectl', CONTROLLER, '--port', 1, '--device', 0, '--type', 'hdd', '--medium', storageDisk02]
            vb.customize ['storageattach', :id, '--storagectl', CONTROLLER, '--port', 2, '--device', 0, '--type', 'hdd', '--medium', storageDisk03]
            vm.memory = 1024
            vm.cpus = 2
        end
    end
end
```
