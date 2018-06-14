# Class: profiles::trac-svn
#
#
class profiles::trac_svn {

class { 'httpd':
  ssl_install => true,
  redir_http  => true,
  }
class { 'svn':
  ssl_install    => true,
  svn_envpath    => '/var/svn/repositories',
  svn_repo_name  => 'bazaarss',
  svn_admin      => 'vchernov',
  svn_admin_pass => 'vchernov',
  svn_user       => 'vboyko',
  svn_user_pass  => 'vboyko',
}
class { 'trac':
  svn_repo_name     => 'bazaarss',
  db_type           => 'mysql',
  fulldbpath        => 'mysql://trac:Pr0m#t3uS@10.128.130.20:3306/test',
  trac_project_name => 'svn',
  trac_envpath      => '/var/trac/trac_projects',
  trac_admin        => 'vchernov',
  trac_admin_pass   => 'vchernov',
  trac_user         => 'vboyko',
  trac_user_pass    => 'vboyko',
}
}