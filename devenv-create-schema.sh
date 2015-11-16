#!/usr/bin/env bash

# load current schema script
cqlsh < schema-script/schema.sql

echo "Cassandra schema created (default config)"
