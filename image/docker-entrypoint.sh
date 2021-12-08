#!/bin/bash

printenv # for debugging

# config kafka
envsubst < "/kafka_server.properties.tpl" > "/opt/kafka/config/server.properties"
echo "cat /opt/kafka/config/server.properties"
cat /opt/kafka/config/server.properties
echo "$(date --iso=ns): done edit kafka config with environment vars"

exec "$@"
