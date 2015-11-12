#!/bin/bash -x
export LANG=en_US # for dnf
# Nov 7,'15 fails on fedora23: curl -sSL https://get.docker.com/ | sh
# see http://docs.docker.com/machine/install-machine/
cat >/etc/yum.repos.d/docker.repo <<-EOF
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/fedora/22
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF
dnf install -yq python2 python2-dnf libselinux-python unzip nano docker-engine wget bridge-utils
systemctl start docker  # will take some time & might fail if VBox guest additions are not installed: "vagrant plugin install vagrant-vbguest"
systemctl enable docker # boot at system time
curl -L https://github.com/projectcalico/calico-docker/releases/download/v0.10.0/calicoctl -o /usr/bin/calicoctl # latest build @ http://www.projectcalico.org/latest/calicoctl
chmod +x /usr/bin/calicoctl # see http://www.projectcalico.org/docker-libnetwork-is-almost-here-and-calico-is-ready/
# see http://www.projectcalico.org/docker-libnetwork-is-almost-here-and-calico-is-ready/ ; latest etcd @ https://github.com/coreos/etcd/releases/
curl -L https://github.com/coreos/etcd/releases/download/v2.2.1/etcd-v2.2.1-linux-amd64.tar.gz -o etcd-v2.2.1-linux-amd64.tar.gz
tar xzvf etcd-v2.2.1-linux-amd64.tar.gz
cd etcd-v2.2.1-linux-amd64
./etcd --advertise-client-urls http://10.0.2.15:4001--listen-client-urls http://0.0.0.0:4001

docker pull calico/node:v0.10.0
docker pull calico/node-libnetwork:v0.5.2
docker pull busybox
docker pull mysql
docker pull centos
docker version
# docker network inspect bridge
# cat /usr/lib/systemd/system/docker.service
