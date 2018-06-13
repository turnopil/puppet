# Class: svn
#
#
class svn {
  package { 'subversion':
    ensure => installed,
  }
  include svn::conf
  include svn::instance
}