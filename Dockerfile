FROM centos
RUN mkdir -p /opt/kafka \
  && cd /opt/kafka \
#  && yum install -y java-latest-openjdk-headless tar \
  && yum install -y java-1.8.0-openjdk-headless tar \
  && curl -s https://www.mirrorservice.org/sites/ftp.apache.org/kafka/2.3.1/kafka_2.12-2.3.1.tgz | tar -xz --strip-components=1 \
  && yum clean all
RUN chmod -R a=u /opt/kafka
WORKDIR /opt/kafka
VOLUME /tmp/kafka-logs /tmp/zookeeper
EXPOSE 2181 2888 3888 9092
