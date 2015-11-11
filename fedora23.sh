#!/bin/bash -x
export LANG=en_US # for dnf
# Nov 7,'15 fails on fedora23: curl -sSL https://get.docker.com/ | sh
# from http://docs.docker.com/machine/install-machine/
cat >/etc/yum.repos.d/docker.repo <<-EOF
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/fedora/22
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF
# optionally export DOCKER_OPTS="--bip=172.18.0.0/16"
dnf install -yq python2 python2-dnf libselinux-python unzip nano docker-engine
# nano /usr/lib/systemd/system/docker.service & modify ExecStart=/usr/bin/docker daemon -H fd:// --bip=172.18.0.0/16 
systemctl start docker # will take some time & will fail on secodn machine unless --bip :-/
systemctl enable docker #boot at system time
docker version
docker pull busybox
docker pull mysql
docker pull centos
# docker network inspect bridge
# cat /usr/lib/systemd/system/docker.service
