#!/usr/bin/env bash

sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
setenforce 0

yum -y install epel-release vim tree iproute net-tools which
