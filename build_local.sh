#!/usr/bin/env bash

# this script will be called by s0_build.sh

export buildDir=/home/tungdt/docker/zookafka/image
export dockerImgTag=daominah/kafka_v3

cd ${buildDir} &&\
        docker build --tag=${dockerImgTag} --file=${buildDir}/Dockerfile .
if [[ $? -eq 0 ]]; then
    echo "built image ${dockerImgTag} with cache"
else
    cd ${buildDir} &&\
        docker build --tag=${dockerImgTag} --file=${buildDir}/Dockerfile --no-cache .
    if [[ $? -eq 0 ]]; then
        echo "built image ${dockerImgTag} with no cache"
    else
        echo "fail to build image ${dockerImgTag} with no cache"
    fi
fi

# docker push ${dockerImgTag} # default to hub.docker.com public
