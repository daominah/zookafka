machines=(local0 local1 local2)
nodeIDs=(1 2 3)
export DOCKER_IMG_TAG=daominah/zookafka # same var in s0
dockerCtnName=zookafka
dockerRunEnvSh=${PWD}/env.sh

nodeIPs=()
for m in ${machines[@]}; do
    nodeIPs+=($(docker-machine ip ${m}))
done

# stop and remove old containers
for i in ${!nodeIDs[@]}; do
    eval $(docker-machine env ${machines[i]})
    echo "cleaning on ${nodeIPs[i]}"
    docker stop ${dockerCtnName} 2>/dev/null;
    docker rm ${dockerCtnName} 2>/dev/null;
    eval $(docker-machine env --unset)
done

# deploy on all nodes
for i in ${!nodeIDs[@]}; do
    # prepare specific node config, will be used in env.sh
    export ZOO_MY_ID=${nodeIDs[i]}
    export ZOO_SERVERS=""
    export KAFKA_ZOOKEEPER_CONNECT=""
    for k in ${!nodeIPs[@]}; do
        if ((i == k)); then
            export ZOO_SERVERS+="server.${ZOO_MY_ID}=0.0.0.0:2888:3888;2181 "
        else
            export ZOO_SERVERS+="server.${nodeIDs[k]}=${nodeIPs[k]}:2888:3888;2181 "
        fi
        KAFKA_ZOOKEEPER_CONNECT+="${nodeIPs[k]}:2181,"
    done
    # remove last delimiter
    export ZOO_SERVERS=${ZOO_SERVERS::-1}
    export KAFKA_ZOOKEEPER_CONNECT=${KAFKA_ZOOKEEPER_CONNECT::-1}

    export KAFKA_BROKER_ID=${nodeIDs[i]}${nodeIDs[i]}
    export KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://${nodeIPs[i]}:9092

    # generate docker run environment file
    dockerRunEnvList=${PWD}/env_docker_run.list
    bash -x ${dockerRunEnvSh} 2>${dockerRunEnvList}
    sed -i 's/+ //' ${dockerRunEnvList}
    sed -i '/^export /d' ${dockerRunEnvList}
    sed -i "s/'//g" ${dockerRunEnvList}

    # pull image and run container image on remote host
    eval $(docker-machine env ${machines[i]})
    docker pull ${DOCKER_IMG_TAG}
    docker run -dit --name ${dockerCtnName} \
        -p 2181:2181 -p 2888:2888 -p 3888:3888 -p 9092:9092 \
        --env-file ${dockerRunEnvList} \
        ${DOCKER_IMG_TAG}
    eval $(docker-machine env --unset)
done
