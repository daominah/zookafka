#!/usr/bin/env bash

set -e

export machines=(local0 local1 local2)

export deployDir=/home/tungdt/docker/zookafka/

for machine in ${machines[@]}; do
    echo "building docker image on ${machine}"

    docker-machine ssh ${machine} mkdir -p ${deployDir}
    docker-machine scp -r . ${machine}:${deployDir}

    docker-machine ssh ${machine} /bin/bash ${deployDir}/build_local.sh &
done
wait
echo "built docker image on all machines"
