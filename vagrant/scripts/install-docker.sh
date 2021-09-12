#!/bin/bash

apt-get -y update
apt-get -y install apt-transport-https ca-certificates curl software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"

apt-get -y update
apt-get -y install docker-ce

usermod -aG docker vagrant

systemctl restart docker.service

mkdir -p /home/vagrant/docker
chown -R vagrant:vagrant /home/vagrant/docker
