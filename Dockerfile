FROM centos

RUN mkdir -p /opt/kafka \
  && mkdir -p /opt/zookeeper \
  && mkdie -p /data/kafka-logs \
  && mkdir -p /data/zookeeper \
  && mkdie -p /tmp/kafka-logs \
  && mkdir -p /tmp/zookeeper \
  && mkdie -p /log/kafka-logs \
  && mkdir -p /log/zookeeper \
  && cd /opt/kafka \
#  && yum install -y java-latest-openjdk-headless tar \
  && yum install -y java-1.8.0-openjdk-headless tar \
  && curl -s https://www.mirrorservice.org/sites/ftp.apache.org/kafka/2.3.1/kafka_2.12-2.3.1.tgz | tar -xz --strip-components=1 \
  && yum clean all

RUN chmod -R a=u /opt/kafka
RUN chmod -R a=u /opt/zookeeper
RUN chmod -R a=u /data/zookeeper

WORKDIR /opt/kafka

COPY zookeeper-starter.sh bin/zookeeper-starter.sh
COPY kafka-starter.sh bin/kafka-starter.sh

RUN chmod +x  bin/kafka-starter.sh
RUN chmod +x  bin/zookeeper-starter.sh

RUN ls -la bin/

VOLUME /tmp/kafka-logs /tmp/zookeeper /data/kafka-logs /data/zookeeper /log/zookeeper /log/kafka-logs

EXPOSE 2181 2888 3888 9092 9308 9309
