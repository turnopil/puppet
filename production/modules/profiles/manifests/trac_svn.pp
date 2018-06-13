# Class: profiles::trac-svn
#
#
class profiles::trac_svn {
  $packages = ['mc', 'nano', 'tree']

  package { 'kernel-devel':
    ensure => installed,
  }
  package { 'epel-release':
    ensure => installed,
  }
  package { $packages:
    ensure  => installed,
    require => Package['kernel-devel']
  }

  class { 'httpd':
  ssl_install => true,
    # resources
  }
  include svn
  include trac
}