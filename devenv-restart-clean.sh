#!/usr/bin/env bash

# clean things up
sh ./devenv-cleanup.sh

# start cassandra locally
sh ./devenv-cassandra-startup.sh

echo "wainting for Cassandra to startup completely"
sleep 30

# recreate schema
sh ./devenv-create-schema.sh

