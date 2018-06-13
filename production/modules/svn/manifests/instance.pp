# Class: svn_instance
#
#
class svn::instance {
  Exec {
    path => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
  }
  file { ['/var/svn', '/var/svn/repositories']:
    ensure => directory,
    owner  => 'apache',
    group  => 'apache',
    mode   => '0664',
  }
  exec { 'svnadmin_create':
    command => 'svnadmin create /var/svn/repositories/bazaarss',
    unless  => 'test -d "/var/svn/repositories/bazaarss"',
    require => [File['/var/svn/repositories'], Class['svn']],
  }
  file { '/var/svn/repositories/bazaarss':
    ensure  => directory,
    owner   => 'apache',
    group   => 'apache',
    mode    => '0664',
    recurse => true,
    require => Exec['svnadmin_create'],
  }
  exec { 'svn_user':
    command => 'htpasswd -c -b /var/svn/repositories/users vchernov vchernov',
    unless  => 'cat /var/svn/repositories/users | grep vchernov',
    require => Exec['svnadmin_create'],
  }
  exec { 'another_svn_user':
    command => 'htpasswd -b /var/svn/repositories/users vboyko vboyko',
    unless  => 'cat /var/svn/repositories/users | grep vboyko',
    require => Exec['svnadmin_create'],
    notify  => Service['httpd'],
  }
}