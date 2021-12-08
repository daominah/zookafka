export dockerImgTag=daominah/kafka_v3 # same var in s0
export dockerCtnName=kafka_v3

# stop and remove old container
echo "stop and remove old container"
docker stop ${dockerCtnName} 2>/dev/null;
docker rm ${dockerCtnName} 2>/dev/null;

set -e

# pull image and run container image on remote host,
# -p 2181:2181 -p 2888:2888 -p 3888:3888 -p 9092:9092 \
docker run -dit --name ${dockerCtnName} \
    -p 9092:9092 -p 9093:9093 \
    --env-file one_instance_env_docker_run.list \
    ${dockerImgTag}
