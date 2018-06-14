# Class: trac
#
#
class trac (
  $svn_repo_name = undef,
  $db_type = 'sqlite',
  $fulldbpath = undef,
  $trac_project_name = undef,
  $trac_envpath = '/var/trac/trac_projects',
  $trac_admin = undef,
  $trac_admin_pass = undef,
  $trac_user = undef,
  $trac_user_pass = undef,
) {
  package { 'trac':
    ensure  => installed,
    require => Package['epel-release'],
  }
  include trac::conf
  include trac::project
}

