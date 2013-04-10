class fpm {
  case $::osfamily {
    'redhat': {
      class { 'fpm::centos': }
    }
    'debian': {
      class { 'fpm::debian': }
    }
    default: {
      #fail("Module '${module_name}' is not currently supported by Puppet Sandbox on ${::operatingsystem}")
    }
  }    

}