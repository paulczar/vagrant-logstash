#!/bin/bash -x

DIR=$(dirname "$0")
HOSTS=$DIR/provision/modules/networking/templates/hosts.erb

echo "127.0.0.1       localhost" > $HOSTS
echo "127.0.1.1       <%= fqdn %>" >> $HOSTS
cat Vagrantfile  | grep centos | awk '{print $6 "\t" $3 "\t" $3 ".<%= domain %>"}' | sed "s/'\|,//g" >> $HOSTS

