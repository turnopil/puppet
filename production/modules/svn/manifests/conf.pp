# Class: svn_httpd
#
#
class svn::conf {

  package { 'mod_dav_svn':
    ensure  => installed,
    require => Package['httpd'],
  }

  file { '/etc/httpd/conf.d/subversion.conf':
    ensure  => present,
    source  => 'puppet:///modules/svn/subversion.conf',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Class['svn'],
    }
}
