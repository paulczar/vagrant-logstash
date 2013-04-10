node 'client1' {
  class { 'elasticsearch':
   confdir                 => '/opt/elasticsearch/config',
   config                   => {
     'node'                 => {
       'name'               => $::hostname
     },
     'index'                => {
       'number_of_replicas' => '0',
       'number_of_shards'   => '5'
     },
     'network'              => {
       'host'               => $::ipaddress_eth1
     }
   }
 }
}