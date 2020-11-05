FROM centos

RUN mkdir -p /opt/kafka \
  && mkdir -p /opt/zookeeper \
  && cd /opt/kafka \
#  && yum install -y java-latest-openjdk-headless tar \
  && yum install -y java-1.8.0-openjdk-headless tar \
  && curl -s https://www.mirrorservice.org/sites/ftp.apache.org/kafka/2.3.1/kafka_2.12-2.3.1.tgz | tar -xz --strip-components=1 \
  && yum clean all

COPY zookeeper-starter.sh bin/zookeeper-starter.sh

RUN chmod -R a=u /opt/kafka
RUN chmod -R a=u /opt/zookeeper

WORKDIR /opt/kafka

RUN ls -la /opt/kafka/bin/

VOLUME /tmp/kafka-logs /tmp/zookeeper /data/kafka-logs /data/zookeeper /log/zookeeper

EXPOSE 2181 2888 3888 9092 9308 9309
