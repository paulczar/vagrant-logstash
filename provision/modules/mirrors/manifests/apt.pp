# == Class: mirrors::apt
#
# This class installs the Puppet Labs APT repository.
#
# === Parameters
#
# === Actions
#
# - Install puppetlabs repository
# - Perform initial sync to update package database
#
# === Requires
#
# === Sample Usage
#
#   class { 'mirrors::apt': }
#
class mirrors::apt {

  $puppetlabs_key = '4BD6EC30'

  exec { 'apt_key_puppetlabs':
    path    => '/bin:/usr/bin',
    unless  => "/usr/bin/apt-key list | /bin/grep -q '${puppetlabs_key}'",
    command => "apt-key adv --keyserver 'pgp.mit.edu' --recv-keys '${puppetlabs_key}'",
    before  => File[ 'puppetlabs.list' ],
  }

  file { 'puppetlabs.list':
    ensure  => present,
    path    => '/etc/apt/sources.list.d/puppetlabs.list',
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('mirrors/puppetlabs.list.erb'),
  }

  exec { 'apt_update':
    command     => '/usr/bin/apt-get update',
    subscribe   => File[ 'puppetlabs.list' ],
    refreshonly => true,
  }

}
