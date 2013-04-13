#########################
# node 'elasticsearch'
# + Elasticsearch 
# + Kibana
#########################
node 'elasticsearch' {
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
  package { 'ruby-devel':     ensure => 'present',  }
  package { 'gcc-c++':     ensure => 'present',  }
  # puppet-upstart on centos broken ...   dodgy it.
  exec { kibana-web :
        cwd        => '/tmp',
        command    => '/usr/bin/ruby /opt/kibana/kibana-daemon.rb start',
        #creates    => '/tmp/kibana.pid',
        require    => File['/opt/kibana/KibanaConfig.rb'],
  }
  file { '/opt/kibana/tmp':
    ensure => link,
    target => '/tmp',
  }
  # now that mess is over with load kibana... try and force dependencies first.
  class { 'kibana': 
    require => Package ['ruby-devel', 'gcc-c++', 'git', 'elasticsearch'],
  }
}

#########################
# node 'elasticsearch2'
# + Elasticsearch
#########################
node 'elasticsearch2' {
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

#########################
# node 'logstash'
# + Logstash (ElasticSearch)
# + Kibana
# + Logstash::Input::File
# + Logstash::Input::TCP
#########################
node 'logstash' {
  class { 'logstash': 
    #status        => 'disabled',
  }
  logstash::input::file { 'syslog':
    path => ['/var/log/messages'],
    start_position => 'beginning',
    type => 'syslog',
    sincedb_path => '/etc/logstash/agent/sincedb/',
  }
  logstash::input::tcp { 'syslog':
    port => '5140',
    type => 'syslog',
  }
  logstash::output::elasticsearch { 'syslog':
    embedded => true,
    type => 'syslog',
  }
  package { 'ruby-devel':     ensure => 'present',  }
  package { 'gcc-c++'   :     ensure => 'present',  }
  # puppet-upstart on centos broken ...   dodgy it.
  exec { kibana-web :
        cwd        => '/tmp',
        command    => '/usr/bin/ruby /opt/kibana/kibana-daemon.rb start',
        #creates    => '/tmp/kibana.pid',
        require    => File['/opt/kibana/KibanaConfig.rb'],
  }
  file { '/opt/kibana/tmp':
    ensure => link,
    target => '/tmp',
  }
  # now that mess is over with load kibana... try and force dependencies first.
  class { 'kibana': 
    require => Package ['ruby-devel', 'gcc-c++', 'git'],
  }
}

#########################
# node 'logstash-twitter'
# + Logstash (ElasticSearch)
# + Kibana
# + Logstash::Input::twitter
#########################
node 'logstash-twitter' {
  class { 'logstash': 
  }
  logstash::input::twitter { 'twitter':
    path      => ['/var/log/messages'],
    type      => 'twitter',
    keywords  => ['bieber'],
    user      => 'USERNAME'
    password  => '*****'
  }
  logstash::output::elasticsearch { 'twitter':
    embedded => true,
    type => 'twitter',
  }
  package { 'ruby-devel':     ensure => 'present',  }
  package { 'gcc-c++'   :     ensure => 'present',  }
  # puppet-upstart on centos broken ...   dodgy it.
  exec { kibana-web :
        cwd        => '/tmp',
        command    => '/usr/bin/ruby /opt/kibana/kibana-daemon.rb start',
        #creates    => '/tmp/kibana.pid',
        require    => File['/opt/kibana/KibanaConfig.rb'],
  }
  file { '/opt/kibana/tmp':
    ensure => link,
    target => '/tmp',
  }
  # now that mess is over with load kibana... try and force dependencies first.
  class { 'kibana': 
    require => Package ['ruby-devel', 'gcc-c++', 'git'],
  }
}

