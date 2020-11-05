#!/bin/bash
### example kafka-ss-0 will give an id of 0 to the kafka broker.id in the stateful cluster in openshift
brokerid=$(hostname | awk -F"-" '{print $3}')
sed -i.bak 's/broker.id=0/broker.id=$brokerid/g' config/server.properties
bin/kafka-server-start.sh