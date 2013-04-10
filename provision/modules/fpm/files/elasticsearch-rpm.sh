#!/bin/bash -x

#install pre-reqs
#yum -y install java-1.7.0-openjdk

# ElasticSearch!
VERSION=0.20.5
PREFIX=/opt
ES_DIR=$PREFIX/elasticsearch
ES_USER=elasticsearch
ULIMIT=80000

cd $PREFIX
curl -L -k https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-$VERSION.tar.gz | tar -xz
mv elasticsearch-$VERSION elasticsearch
cd elasticsearch/bin/
curl -L -k http://github.com/elasticsearch/elasticsearch-servicewrapper/tarball/master | tar -xz
mv *servicewrapper*/service $ES_DIR/bin/
mkdir -p $ES_DIR/extras

$ES_DIR/bin/plugin -install elasticsearch/elasticsearch-river-rabbitmq/1.4.0
$ES_DIR/bin/plugin -install lukas-vlcek/bigdesk
$ES_DIR/bin/plugin -install karmi/elasticsearch-paramedic
$ES_DIR/bin/plugin -install mobz/elasticsearch-head

#### GRRRR init script fails when launching as user other than root.   too lazy to work out why right now.
#sed -i "s/^.*RUN_AS_USER=.*/RUN_AS_USER=$ES_USER/" /opt/elasticsearch/bin/service/elasticsearch
sed -i "s/^.*ULIMIT_N=.*/ULIMIT_N=$ULIMIT/" /opt/elasticsearch/bin/service/elasticsearch

cat > $ES_DIR/extras/elasticsearch-post-install.sh << EOF 
#!/bin/sh

adduser $ES_USER
chown -R $ES_USER:$ES_USER $ES_DIR
$ES_DIR/bin/service/elasticsearch install
ln -s `readlink -f $ES_DIR/bin/service/elasticsearch` /usr/local/bin/rcelasticsearch
EOF

chmod 755 $ES_DIR/extras/elasticsearch-post-install.sh

cat >  $ES_DIR/extras/elasticsearch-pre-uninstall.sh << EOF
#!/bin/sh

userdel elasticsearch
/opt/elasticsearch/bin/service/elasticsearch remove
rm -f /usr/local/bin/rcelasticsearch
EOF

chmod 755 $ES_DIR/extras/elasticsearch-pre-uninstall.sh

cd /vagrant/packages/rpm/

fpm -s dir -t rpm -d 'java-1.7.0-openjdk' --post-install "$ES_DIR/extras/elasticsearch-post-install.sh" \
		--pre-uninstall "$ES_DIR/extras/elasticsearch-pre-uninstall.sh" -n "elasticsearch" -v $VERSION $ES_DIR

# echo ... lets fire it up and see if it works.		
#adduser $ES_USER
#chown -R $ES_USER:$ES_USER $ES_DIR
#$ES_DIR/bin/service/elasticsearch install
#ln -s `readlink -f $ES_DIR/bin/service/elasticsearch` /usr/local/bin/rcelasticsearch		
#service elasticsearch start
#sleep 5
#curl http://localhost:9200		
