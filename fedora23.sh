#!/bin/bash -x
export LANG=en_US # for dnf
echo 'export LANG=en_US' >> /etc/profile.d/custom.sh
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
dnf install -yq rpm dnf
dnf install -yq python2 python2-dnf libselinux-python unzip nano docker-engine wget bridge-utils traceroute
# will take some time & might fail even if VBox Guest Additions are installed: "vagrant plugin install vagrant-vbguest"
systemctl start docker # || { sleep 3; systemctl start docker } # retry once
systemctl enable docker # boot at system time
docker pull calico/node:v0.10.0 > /dev/null
docker pull calico/node-libnetwork:v0.5.2 > /dev/null
docker pull busybox > /dev/null
docker pull mysql > /dev/null
docker pull centos > /dev/null
curl -L --silent https://github.com/projectcalico/calico-docker/releases/download/v0.10.0/calicoctl -o /usr/bin/calicoctl # latest build @ http://www.projectcalico.org/latest/calicoctl
chmod +x /usr/bin/calicoctl # see http://www.projectcalico.org/docker-libnetwork-is-almost-here-and-calico-is-ready/
# see http://www.projectcalico.org/docker-libnetwork-is-almost-here-and-calico-is-ready/ ; latest etcd @ https://github.com/coreos/etcd/releases/
curl -L --silent https://github.com/coreos/etcd/releases/download/v2.2.1/etcd-v2.2.1-linux-amd64.tar.gz -o etcd-linux-amd64.tar.gz
tar xzf etcd-linux-amd64.tar.gz --exclude Documentation --exclude '*.md' -C /usr/bin --strip-components=1
# this needs some work
echo $1
echo "./etcd --advertise-client-urls http://$1:4001 --listen-client-urls http://0.0.0.0:4001"
./etcd --advertise-client-urls http://$1:4001 --listen-client-urls http://0.0.0.0:4001
docker version
etcd --version
# docker network inspect bridge
# cat /usr/lib/systemd/system/docker.service
