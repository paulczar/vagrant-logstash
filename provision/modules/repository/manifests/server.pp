# class repository::server

class repository::server {

  #include repository::server-yum
  #include repository::server-apt

  case $::osfamily {
    'redhat': {
      class { 'repository::server-yum': }
    }
##    'debian': {
##      class { 'repository::server::apt': }
##    }
    default: {
      #fail("Module '${module_name}' is not currently supported by Puppet Sandbox on ${::operatingsystem}")
    }
  }
}