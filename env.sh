# Kafka config, is used for  kafka_server.properties.tpl in docker-entrypoint
# Example: kafka.apache.org/documentation/#prodconfig
# Run Kafka without Zookeeper: github.com/apache/kafka/blob/trunk/config/kraft/README.md

export KAFKA_BROKER_ID=${KAFKA_BROKER_ID} # defined in s1_run, example: 11, 22, 33
# config "log.dirs" is "/kafka-logs" in container, mount to host dir if needed
# config "zookeeper.connect"

export KAFKA_LISTENERS=${KAFKA_LISTENERS} # defined in s1
export KAFKA_ADVERTISED_LISTENERS=${KAFKA_ADVERTISED_LISTENERS} # defined in s1

export KAFKA_NUM_PARTITIONS=3
export KAFKA_DEFAULT_REPLICATION_FACTOR=2
export KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR=2
export KAFKA_MIN_INSYNC_REPLICAS=1

# https://docs.confluent.io/current/kafka/deployment.html#jvm recomend Xmx=Xms,
# https://stackoverflow.com/a/36649296/4097963
export KAFKA_HEAP_OPTS="-Xmx6G -Xms511M"
export KAFKA_MESSAGE_MAX_BYTES=15000000
