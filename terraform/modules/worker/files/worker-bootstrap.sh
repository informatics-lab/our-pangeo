#!/bin/bash
export JUPYTERHUB_HOST="${jadehub_private_ip}"

# install deps
yum update -y
yum install -y git nfs-utils

echo "${jadehub_private_ip} jupyterhub" >> /etc/hosts

# mount network fileystems
service nfs start
mkdir -p /mnt/jade-notebooks
mount -t nfs4 -o nfsvers=4.1 $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone).fs-841df44d.efs.eu-west-1.amazonaws.com:/ /mnt/jade-notebooks

# install docker
yum install -y docker

# Make docker listen on tcp
sed -i '/^OPTIONS/ d' /etc/sysconfig/docker
echo "OPTIONS=\"--default-ulimit nofile=1024:4096 -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock\"" >> /etc/sysconfig/docker

# Start Docker
service docker start

# pull scientific environment image
docker pull quay.io/informaticslab/asn-serve:v1.0.1

# run config
docker run -d --add-host "jupyterhub:${jadehub_private_ip}" swarm join --advertise=$(ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'):2375 consul://jupyterhub:8500
