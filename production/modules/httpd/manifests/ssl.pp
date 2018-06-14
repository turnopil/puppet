# Class: ssl
#
#
class httpd::ssl {
  $redir_http = $httpd::redir_http
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
  content => template('httpd/ssl.conf.erb'),
  owner   => 'root',
  group   => 'root',
  mode    => '0640',
  require => Package['mod_ssl'],
  notify  => Service['httpd'],
}

}