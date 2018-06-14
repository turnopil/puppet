# Class: profiles:base
#
#
class profiles::base {
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
}
