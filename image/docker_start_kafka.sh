#!/usr/bin/env bash

echo "$(date --iso=ns): wait for zookeeper to start up"
zkServer.sh status
exitCode=$?
if [ $exitCode -ne 0 ]; then
    echo "$(date --iso=ns): zkServer.sh status exitCode: $exitCode"
    sleep 5
    exit
else
    echo "$(date --iso=ns): zookeeper started, about to start kafka"
    /opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties
    echo "$(date --iso=ns):  kafka stopppppppppppppppppppppppppppppppppppppppppp"
fi
