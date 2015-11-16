#!/bin/bash

fwd_dns="8.8.8.8"

echo "Provisioning Docker ..."
echo "***********************"
echo " "
sudo sh -c 'echo "DOCKER_OPTS=\"-H tcp://0.0.0.0:4444 -H unix:///var/run/docker.sock\"" >> /etc/default/docker'
sudo restart docker
sleep 5
echo " "
echo "Starting containers ..."
echo "***********************"
echo " "

echo "cleaning up ..."
echo "***************"
sudo docker stop $(sudo docker ps -qa)
sudo docker rm $(sudo docker ps -qa)
echo " "

sudo mkdir -p /srv/seed1

# first find the docker0 interface assigned IP
DOCKER0_IP=$(ip -o -4 addr list docker0 | awk '{split($4,a,"/"); print a[1]}')
    
# then launch a skydns container to register our network addresses
dns=$(sudo docker run -d \
    -p $DOCKER0_IP:53:53/udp \
    --name skydns \
    crosbymichael/skydns \
    -nameserver $fwd_dns:53 \
    -domain docker)
echo "Starting dns regristry ..."
echo "**************************"
echo $dns
echo " "

sleep 5

# inspect the container to extract the IP of our DNS server
DNS_IP=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' skydns)

# launch skydock as our listener of container events in order to register/deregister all the names on skydns
skydock=$(sudo docker run -d \
	-v /var/run/docker.sock:/docker.sock \
	--name skydock \
	crosbymichael/skydock \
	-ttl 30 \
	-environment dev \
	-s /docker.sock \
	-domain docker \
	-skydns "http://$DNS_IP:8080")
echo "Starting docker event listener ..."
echo "**********************************"
echo $skydock
echo " "

sleep 5

# boot a cassandra node as a seed 
seed1=$(sudo docker run -itd \
	--name=seed1 \
	-h seed1.cassandranode-revit.dev.docker \
	--dns=$DNS_IP \
	-e "http_proxy=$http_proxy" \
	-e "https_proxy=$https_proxy" \
	-e "OPTS_CENTER=true" \
	-p 7000:7000 \
	-p 7001:7001 \
	-p 8888:8888 \
	-p 7199:7199 \
	-p 9042:9042 \
	-p 9160:9160 \
	-v /srv/seed1/commitlog:/var/lib/cassandra/commitlog \
	-v /srv/seed1/data:/var/lib/cassandra/data \
	-v /srv/seed1/saved_caches:/var/lib/cassandra/saved_caches \
	prodriguezdefino/cassandranode-revit)
echo "Starting seed node seed1.cassandranode.dev.docker ..."
echo "*****************************************************"
echo $seed1
echo " "
