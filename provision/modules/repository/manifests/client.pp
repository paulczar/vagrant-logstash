# class repository::client

class repository::client {

  case $::osfamily {
    'redhat': {
      class { 'repository::client-yum': }
    }
##    'debian': {
##      class { 'repository::client-apt': }
##    }
    default: {
      #fail("Module '${module_name}' is not currently supported by Puppet Sandbox on ${::operatingsystem}")
    }
  }

}