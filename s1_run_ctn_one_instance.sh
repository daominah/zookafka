export DOCKER_IMG_TAG=daominah/zookafka # same var in s0
dockerCtnName=zookafka
dockerRunEnvSh=${PWD}/env_one_instance.sh

set -x

export ZOO_SERVERS="server.1=127.0.0.1:2888:3888;2181"
export KAFKA_ZOOKEEPER_CONNECT="127.0.0.1:2181"

# stop and remove old containers
echo "cleaning on current machine"
docker stop ${dockerCtnName} 2>/dev/null;
docker rm ${dockerCtnName} 2>/dev/null;

set +x

# docker run on remote machines
set -e

# prepare specific node config, will be used in env.sh
export ZOO_MY_ID=1

export KAFKA_BROKER_ID=11
export KAFKA_LISTENERS=PLAINTEXT://0.0.0.0:9092
export KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://127.0.0.1:9092

# generate docker run environment file
dkrEnv=${PWD}/env_docker_run.list; bash -x ${dockerRunEnvSh} 2>${dkrEnv}
sed -i 's/+ //' ${dkrEnv}; sed -i '/^export /d' ${dkrEnv}; sed -i "s/'//g" ${dkrEnv}

# pull image and run container image on remote host,
# -p 2181:2181 -p 2888:2888 -p 3888:3888 -p 9092:9092 \
docker run -dit --name ${dockerCtnName} \
    -p 2181:2181 -p 2888:2888 -p 3888:3888 -p 9092:9092 \
    --env-file ${dkrEnv} \
    ${DOCKER_IMG_TAG}
