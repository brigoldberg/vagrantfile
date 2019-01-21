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

