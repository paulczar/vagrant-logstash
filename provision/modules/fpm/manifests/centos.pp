#yum -y install ruby rubygems ruby-devel make gcc rpm-build git
# gem install fpm

class fpm::centos {
  package { 'ruby-devel':
    ensure => 'present',
  }
  package { 'rubygems':
    ensure => 'present',
  }
  package { 'make':
    ensure => 'present',
  }
  package { 'gcc':
    ensure => 'present',
  }
  package { 'rpm-build':
    ensure => 'present',
  }
  package { 'git':
    ensure => 'present',
  }
  package { 'fpm':
    ensure => 'present',
    provider => 'gem',
    require  => [ Package["rubygems"], Package["ruby-devel"] ],
  }

  file { 'redis-rpm.sh':
    ensure  => present,
    path    => '/tmp/redis-rpm.sh',
    owner   => vagrant,
    group   => vagrant,
    mode    => '0755',
    replace => true,
    source  => 'puppet:///modules/fpm/redis-rpm.sh',
  }
  exec { 'redis-rpm':
    command => '/tmp/redis-rpm.sh',
    creates => '/vagrant/packages/rpm/redis-2.6.11-1.x86_64.rpm',
    require => Package['fpm'],
    user => 'root',
  }

  file { 'elasticsearch-rpm.sh':
    ensure  => present,
    path    => '/tmp/elasticsearch-rpm.sh',
    owner   => vagrant,
    group   => vagrant,
    mode    => '0755',
    replace => true,
    source  => 'puppet:///modules/fpm/elasticsearch-rpm.sh',
  }
  exec { 'elasticsearch-rpm':
    command => '/tmp/elasticsearch-rpm.sh',
    creates => '/vagrant/packages/rpm/elasticsearch-0.20.5-1.x86_64.rpm',
    require => Package['fpm'],
    user => 'root',
  }

  file { 'logstash-rpm.sh':
    ensure  => present,
    path    => '/tmp/logstash-rpm.sh',
    owner   => vagrant,
    group   => vagrant,
    mode    => '0755',
    replace => true,
    source  => 'puppet:///modules/fpm/logstash-rpm.sh',
  }
  exec { 'logstash-rpm':
    command => '/tmp/logstash-rpm.sh',
    creates => '/vagrant/packages/rpm/logstash-1.1.9-1.x86_64.rpm',
    require => Package['fpm'],
    user => 'root',
  }


}