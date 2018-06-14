# Class: svn
#
#
class svn (
  $ssl_install = true,
  $svn_envpath = '/var/svn/repositories',
  $svn_repo_name = undef,
  $svn_admin = undef,
  $svn_admin_pass = undef,
  $svn_user = undef,
  $svn_user_pass = undef,
) {
  package { 'subversion':
    ensure => installed,
  }
  include svn::conf
  include svn::instance
}