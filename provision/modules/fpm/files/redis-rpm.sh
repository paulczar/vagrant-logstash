#!/bin/bash -x

VERSION=2.6.11
PREFIX=/

cd /tmp
curl  -L -k http://redis.googlecode.com/files/redis-$VERSION.tar.gz| tar -xz
cd redis-$VERSION
make
# should probably run the test ....
#make test

mkdir -p /tmp/build-redis-$VERSION/$PREFIX/usr/bin
mkdir -p /tmp/build-redis-$VERSION/$PREFIX/etc/init.d
mkdir -p /tmp/build-redis-$VERSION/$PREFIX/etc/redis

cp src/{redis-benchmark,redis-check-aof,redis-check-dump,redis-cli,redis-server} /tmp/build-redis-$VERSION/$PREFIX/usr/bin

cp redis.conf /tmp/build-redis-$VERSION/$PREFIX/etc/redis/redis.conf

sed -i "s/daemonize no/daemonize yes/" /tmp/build-redis-$VERSION/$PREFIX/etc/redis/redis.conf

curl -L -k https://raw.github.com/gist/257849/9f1e627e0b7dbe68882fa2b7bdb1b2b263522004/redis-server > /tmp/build-redis-$VERSION/$PREFIX/etc/init.d/redis-server

chmod 755 /tmp/build-redis-$VERSION/$PREFIX/etc/init.d/redis-server

sed -i "s|/usr/local/sbin/redis-server|/usr/bin/redis-server|" /tmp/build-redis-$VERSION/$PREFIX/etc/init.d/redis-server

cd /vagrant/packages/rpm/

fpm -s dir -t rpm -n redis -v $VERSION -C /tmp/build-redis-$VERSION/ .


