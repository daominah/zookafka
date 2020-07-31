# Zookeeper config
export ZOO_STANDALONE_ENABLED=false
export ZOO_ADMINSERVER_ENABLED=false
export ZOO_4LW_COMMANDS_WHITELIST=stat # telnet can check status
export ZOO_MY_ID=${ZOO_MY_ID} # defined in s1
export ZOO_SERVERS=${ZOO_SERVERS} # defined in s1

# Kafka config, is used for  kafka_server.properties.tpl in docker-entrypoint
export KAFKA_ZOOKEEPER_CONNECT=${KAFKA_ZOOKEEPER_CONNECT} # defined in s1
export KAFKA_BROKER_ID=${KAFKA_BROKER_ID} # defined in s1
export KAFKA_ADVERTISED_LISTENERS=${KAFKA_ADVERTISED_LISTENERS} # defined in s1
