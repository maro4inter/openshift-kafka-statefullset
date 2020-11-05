!#/bin/bash
### example zookeeper-ss-0 will give an id of 0 to the zookeeper node in the stateful cluster in openshift
myid=$(hostname | awk -F"-" '{print $3}')
echo "$myid" > /data/zookeeper/myid
bin/zookeeper-server-start.sh