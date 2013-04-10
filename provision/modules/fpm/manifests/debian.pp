class fpm::debian {
  package { 'rubygems':
    ensure => 'present',
  }
  package { 'make':
    ensure => 'present',
  }
  package { 'gcc':
    ensure => 'present',
  }
  package { 'git':
    ensure => 'present',
  }
  package { 'fpm':
    ensure => 'present',
    provider => 'gem',
    require  => Package["rubygems"],
  }
}