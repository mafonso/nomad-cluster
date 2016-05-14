#!/bin/bash
set -eux

sudo rpm --import http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-7
sudo rpm --import https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7
sudo yum -q -y install epel-release
sudo yum -q -y install deltarpm
sudo yum -q -y update
sudo yum -q -y install ansible

echo "localhost ansible_connection=local" | sudo tee /etc/ansible/hosts
