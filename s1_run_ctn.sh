machines=(local0 local1 local2)
nodeIDs=(1 2 3)
export DOCKER_IMG_TAG=daominah/zookafka # same var in s0
dockerCtnName=zookafka
dockerRunEnvSh=${PWD}/env.sh

set -x

# set shared config fields in cluster
nodeIPs=()
for m in ${machines[@]}; do
    nodeIPs+=($(docker-machine ip ${m}))
done

export ZOO_SERVERS=""
export KAFKA_ZOOKEEPER_CONNECT=""
for k in ${!nodeIPs[@]}; do
    export KAFKA_ZOOKEEPER_CONNECT+="${nodeIPs[k]}:2181,"
    export ZOO_SERVERS+="server.${nodeIDs[k]}=${nodeIPs[k]}:2888:3888;2181 "
done
export ZOO_SERVERS=${ZOO_SERVERS::-1}
export KAFKA_ZOOKEEPER_CONNECT=${KAFKA_ZOOKEEPER_CONNECT::-1}


# pull latest image
for i in ${!nodeIDs[@]}; do
    eval $(docker-machine env ${machines[i]})
    docker pull ${DOCKER_IMG_TAG}
    eval $(docker-machine env --unset)
done

# stop and remove old containers
for i in ${!nodeIDs[@]}; do
    eval $(docker-machine env ${machines[i]})
    echo "cleaning on ${nodeIPs[i]}"
    docker stop ${dockerCtnName} 2>/dev/null;
    docker rm ${dockerCtnName} 2>/dev/null;
    eval $(docker-machine env --unset)
done

set +x

# docker run on remote machines
set -e

for i in ${!nodeIDs[@]}; do
    # prepare specific node config, will be used in env.sh
    export ZOO_MY_ID=${nodeIDs[i]}

    export KAFKA_BROKER_ID=${nodeIDs[i]}${nodeIDs[i]}
    export KAFKA_LISTENERS=PLAINTEXT://0.0.0.0:9092
    export KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://${nodeIPs[i]}:9092

    # generate docker run environment file
    dkrEnv=${PWD}/env_docker_run.list; bash -x ./env.sh 2>${dkrEnv}
    sed -i 's/+ //' ${dkrEnv}; sed -i '/^export /d' ${dkrEnv}; sed -i "s/'//g" ${dkrEnv}

    # pull image and run container image on remote host,
    # -p 2181:2181 -p 2888:2888 -p 3888:3888 -p 9092:9092 \
    eval $(docker-machine env ${machines[i]})
    docker run -dit --name ${dockerCtnName} \
        --network host \
        --env-file ${dkrEnv} \
        ${DOCKER_IMG_TAG}
    eval $(docker-machine env --unset)
done
