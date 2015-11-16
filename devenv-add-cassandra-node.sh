#!/bin/bash 

# check for first parameter (worker's name)
if [ -z "$1" ]
  then
    echo "No argument supplied, worker name needed."
    exit 1
fi

# check for second parameter (port shift for worker node)
if [ -z "$2" ]
  then
    echo "port shift needed."
    exit 1
fi

# check for third parameter (seed node address)
if [ -z "$3" ]
  then
    seedaddrss="seed1.cassandranode-revit.dev.docker"
    echo "no seed node provided, default will be used ($seedaddrss)."
  else
    seedaddrss=$3  
fi


# check second paramenter to be numeric
if [ "$2" -eq "$2" ] 2>/dev/null 
then
   echo "ports will be shifted by $2"
else
   echo "error: $2 is not a number." 
   exit 1
fi

# creating data directory
sudo mkdir -p /srv/$1


# seting port shift for host mapping
port7000=$((7000+$2))
port7001=$((7001+$2))
port7199=$((7199+$2))
port9042=$((9042+$2))
port9160=$((9160+$2))

# inspect the container to extract the IP of our DNS server
DNS_IP=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' skydns)

# now boot another node for this ring 
newnode=$(sudo docker run -itd \
	--name=$1 \
	-h $1.cassandranode-revit.dev.docker \
	--dns=$DNS_IP \
	-e "http_proxy=$http_proxy" \
	-e "https_proxy=$https_proxy" \
	-e "SEEDS_IPS=$seedaddrss" \
	-e "OPTS_CENTER=true" \
	-p $port7000:7000 \
	-p $port7001:7001 \
	-p $port7199:7199 \
	-p $port9042:9042 \
	-p $port9160:9160 \
	-v /srv/$1/commitlog:/var/lib/cassandra/commitlog \
	-v /srv/$1/data:/var/lib/cassandra/data \
	-v /srv/$1/saved_caches:/var/lib/cassandra/saved_caches \
	prodriguezdefino/cassandranode-revit)
echo "Starting node $1.cassandranode.dev.docker ..."
echo "************************************************"
echo $newnode
echo " "
