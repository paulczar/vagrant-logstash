class 'kibana-hack' {
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