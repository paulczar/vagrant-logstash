class repository::client-yum {

  file { 'sandbox.repo':
    ensure  => present,
    path    => '/etc/yum.repos.d/sandbox.repo',
    owner   => root,
    group   => root,
    mode    => '0644',
    replace => true,
    source  => 'puppet:///modules/repository/sandbox.repo',
  }

}
