# ZooKafka

Run Zookeeper and Kafka in a same container.

PID 1 is a [supervisord](https://packages.debian.org/buster/supervisor).
It maintains zkServer and a script that check Zookeeper status to start
Kafka.

Git [link](https://github.com/daominah/zookafka.git).

## Build

Run script `image/s0_build_img.sh`

## Deploy

Script `s1_run_ctn.sh` deploy on 3 hosts (remote or virtual) with
docker-machine.

### Local requirements

* Install docker-machine and Ubuntu package virtualbox (
  [sa_local_prepare.sh](./sa_local_prepare.sh)).
* Create docker machines [sb_create_machines.sh](./sb_create_machines.sh).

## References
[supervisord stdout](https://stackoverflow.com/a/26897648/4097963)
