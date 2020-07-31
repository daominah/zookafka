# ZooKafka

Run Zookeeper and Kafka in a same container.

PID 1 is a [supervisord](https://packages.debian.org/buster/supervisor).
It monitors 2 processes, zkServer and a script check Zookeeper status
before running Kafka.

Git [repo](https://github.com/daominah/zookafka.git).

## Build

Run script [s0_build_img.sh]

## Deploy

Script [s1_run_ctn.sh] deploy on 3 hosts (virtual, can be changed
to remote) by using docker-machine. Basically it does:

````bash
docker run -dit --name zookafka \
    --network host \
    --env-file env_docker_run.list \
    daominah/zookafka
````

env_docker_run.list is an auto generated file for each container.

Note: because of a Zookeeper [bug](), instead of config
server.id=0.0.0.0:2888:3888;2181, it must be specific IP and the
container 

### Test on local

* Check zookeeper status:

````bash
watch -n 5 bash -c 'printf '\ec'; for i in 0 1 2; do echo "stat" | nc 192.168.99.10$i 2181; done'

for i in 0 1 2; do echo "stat" | nc 192.168.99.10$i 2181 | grep Mode; done
````

* Produce, consume test Kafka messages:

````bash
echo "hello at $(date --iso=ns)" | kafka-console-producer.sh \
    --bootstrap-server localhost:9092 \
    --topic topic1

kafka-console-consumer.sh \
    --bootstrap-server localhost:9092 \
    --from-beginning --topic topic1
````

* Get Kafka topic, group detail:

````bash
kafka-topics.sh --describe --zookeeper localhost:2181 --topic topic0

kafka-consumer-groups.sh  --list --bootstrap-server localhost:9092

kafka-consumer-groups.sh --bootstrap-server localhost:9092 \
    --describe --group group0
```` 

### Copy docker image to machines

Copy is faster than pull in local.

````bash
docker save -o zookafka.dimg daominah/zookafka
for i in 0 1 2; do
    docker-machine scp ./zookafka.dimg local$i:/home/docker/zookafka.dimg
    docker-machine ssh local$i "docker load -i /home/docker/zookafka.dimg"
done
````

## References

* [Choose the number of partitions for Kafka topic](
https://www.confluent.io/blog/how-choose-number-topics-partitions-kafka-cluster/)
* [supervisord redirect stdout](https://stackoverflow.com/a/26897648/4097963)
* [Example Kafka prod config](
https://kafka.apache.org/documentation/#prodconfig)
* [Zookeeper clients gets connection timeout when restart the leader](
https://issues.apache.org/jira/browse/ZOOKEEPER-3828?page=com.atlassian.jira.plugin.system.issuetabpanels%3Aall-tabpanel)
