FROM openjdk:8-jre-buster
RUN apt-get update

RUN apt-get install -qy wget

# Kafka 3.0.0, released 2021-09-21, https://kafka.apache.org/downloads
ENV kafkaVer 3.0.0
ENV kafkaVerFull 2.13-3.0.0
ENV kafkaMirror https://downloads.apache.org/kafka
RUN wget -q ${kafkaMirror}/${kafkaVer}/kafka_${kafkaVerFull}.tgz
RUN tar -xzf kafka_${kafkaVerFull}.tgz -C /opt &&\
    rm kafka_${kafkaVerFull}.tgz
RUN mv /opt/kafka_${kafkaVerFull} /opt/kafka

RUN apt-get install -qy procps net-tools telnet iputils-ping vim gettext-base

ENV PATH="${PATH}:/opt/kafka/bin"

COPY kafka_server.properties.tpl /
COPY docker-entrypoint.sh /

EXPOSE 9092
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/opt/kafka/bin/kafka-server-start.sh", "/opt/kafka/config/server.properties"]
