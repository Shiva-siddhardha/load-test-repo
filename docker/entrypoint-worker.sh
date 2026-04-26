#!/bin/bash
set -e

# Get this container's IP for RMI
WORKER_IP=$(hostname -i)

echo "Starting JMeter worker on IP: $WORKER_IP"

JVM_ARGS="-Xms2g -Xmx2g \
  -Djava.rmi.server.hostname=$WORKER_IP \
  -Dserver.rmi.localport=50000 \
  -Dserver_port=1099"

export JVM_ARGS

exec jmeter-server \
  -Dserver.rmi.localport=50000 \
  -Dserver_port=1099 \
  -Djava.rmi.server.hostname=$WORKER_IP \
  -Dserver.rmi.ssl.disable=true
