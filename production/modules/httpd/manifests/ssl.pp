# Class: ssl
#
#
class httpd::ssl {

package { 'mod_ssl':
  ensure => installed,
}

file { 'server.crt':
  ensure  => present,
  path    => '/etc/httpd/conf/server.crt',
  source  => 'puppet:///modules/httpd/server.crt',
  owner   => 'root',
  group   => 'root',
  mode    => '0600',
  require => Package['mod_ssl'],
}

file { 'server.key':
  ensure  => present,
  path    => '/etc/httpd/conf/server.key',
  source  => 'puppet:///modules/httpd/server.key',
  owner   => 'root',
  group   => 'root',
  mode    => '0600',
  require => Package['mod_ssl'],
}

file { 'ssl.conf':
  ensure  => file,
  path    => '/etc/httpd/conf.d/ssl.conf',
  source  => 'puppet:///modules/httpd/ssl.conf',
  owner   => 'root',
  group   => 'root',
  mode    => '0640',
  require => Package['mod_ssl'],
  notify  => Service['httpd'],
}

}