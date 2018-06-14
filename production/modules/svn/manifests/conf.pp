# Class: svn_httpd
#
#
class svn::conf {
  $ssl_install   = $svn::ssl_install
  $svn_repo_name = $svn::svn_repo_name
  $svn_envpath   = $svn::svn_envpath

package { 'mod_dav_svn':
  ensure  => installed,
  require => Package['httpd'],
}

file { '/etc/httpd/conf.d/subversion.conf':
  ensure  => present,
  content => template('svn/subversion.conf.erb'),
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
  require => Class['svn'],
}
}
