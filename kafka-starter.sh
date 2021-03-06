#!/bin/bash
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

if [ $# -lt 1 ];
then
	echo "USAGE: $0 [-daemon] server.properties [--override property=value]*"
	exit 1
fi
base_dir=$(dirname $0)

if [ "x$KAFKA_LOG4J_OPTS" = "x" ]; then
    export KAFKA_LOG4J_OPTS="-Dlog4j.configuration=file:$base_dir/../config/log4j.properties"
fi

if [ "x$KAFKA_HEAP_OPTS" = "x" ]; then
    export KAFKA_HEAP_OPTS="-Xmx1G -Xms1G"
fi

EXTRA_ARGS=${EXTRA_ARGS-'-name kafkaServer -loggc'}

COMMAND=$1
case $COMMAND in
  -daemon)
    EXTRA_ARGS="-daemon "$EXTRA_ARGS
    shift
    ;;
  *)
    ;;
esac


### example kafka-ss-0 will give an id of 0 to the kafka broker.id in the stateful cluster in openshift
brokerid=$(hostname | awk -F"-" '{print $3}')
oldbrokerid="broker.id=0"
newbrokerid="broker.id="$brokerid
sed -i.bak "s|$oldbrokerid|$newbrokerid|g" /opt/kafka/config/server.properties

hostnamefull=$(hostname -A)
hostnamefull=`echo $hostnamefull | sed 's/ *$//g'`
##echo "advertised.host.name="$hostnamefull >> /opt/kafka/config/server.properties
echo "advertised.listeners=PLAINTEXT://"$hostnamefull":9092" >> /opt/kafka/config/server.properties

# Maps listener names to security protocols, the default is for them to be the same. See the config documentation for more details
#listener.security.protocol.map=PLAINTEXT:PLAINTEXT,SSL:SSL,SASL_PLAINTEXT:SASL_PLAINTEXT,SASL_SSL:SASL_SSL
echo "listener.security.protocol.map=PLAINTEXT:PLAINTEXT" >> /opt/kafka/config/server.properties

exec $base_dir/kafka-run-class.sh $EXTRA_ARGS kafka.Kafka "$@"
