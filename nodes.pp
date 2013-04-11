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

node 'client2' {
  class { 'logstash': 
    status        => 'disabled',
  }
  logstash::input::file { 'syslog':
    path => ['/var/log/messages'],
    start_position => 'beginning',
    type => 'syslog',
    sincedb_path => '/etc/logstash/agent/sincedb/',
  }
#  logstash::output::elasticsearch { 'syslog':
#    host => 'client1',
#    type => 'syslog',
#  }
  logstash::output::stdout { 'syslog':
    type => 'syslog',
  }
}