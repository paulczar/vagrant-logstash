#
# site.pp - defines defaults for vagrant provisioning
#

# use run stages for minor vagrant environment fixes
stage { 'pre': before    => Stage['main'] }
class { 'mirrors': stage => 'pre' }
class { 'vagrant': stage => 'pre' }

class { 'puppet': }
class { 'networking': }

if $hostname == 'puppet' {
  class { 'puppet::server': }
  class { 'repository::server': }
} elsif $hostname == 'fpm' {
    class { 'fpm': }
} else {
  class { 'repository::client': stage => 'pre' }    
}
