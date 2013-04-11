#!/bin/bash -x

#install pre-reqs
#yum -y install java-1.7.0-openjdk

VERSION=1.1.9
LS_DIR=/usr/share/logstash

mkdir -p $LS_DIR

cd $LS_DIR

wget https://logstash.objects.dreamhost.com/release/logstash-$VERSION-monolithic.jar
mv logstash-$VERSION-monolithic.jar logstash.jar

#curl http://cookbook.logstash.net/recipes/using-init/logstash.sh > /etc/init.d/logstash

#sed -i "s|^CONFIG_DIR.*$|CONFIG_DIR=$LS_DIR/conf.d|" /etc/init.d/logstash
#sed -i "s|^LOGFILE.*$|LOGFILE=$LS_DIR/log/logstash.log|" /etc/init.d/logstash
#sed -i "s|^#JAVAMEM.*$|JAVAMEM=256M|" /etc/init.d/logstash

cd /vagrant/packages/rpm
fpm -s dir -t rpm -d 'java-1.7.0-openjdk' -n "logstash" -v $VERSION $LS_DIR

