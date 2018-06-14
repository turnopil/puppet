# Class: svn_instance
#
#
class svn::instance {
  $svn_repo_name = $snv::svn_repo_name
  $svn_envpath = '/var/svn/repositories'
  $svn_admin = $svn::svn_admin
  $svn_admin_pass = $svn::svn_admin_pass
  $svn_user = $svn::svn_user
  $svn_user_pass = $svn::svn_user_pass

  Exec {
    path => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
  }
  file { ['/var/svn', $svn_envpath]:
    ensure => directory,
    owner  => 'apache',
    group  => 'apache',
    mode   => '0664',
  }
  exec { 'svnadmin_create':
    command => "svnadmin create ${svn_envpath}/${svn_repo_name}",
    unless  => "test -d \"${svn_envpath}/${svn_repo_name}\"",
    require => [File[$svn_envpath}], Class['svn']],
  }
  file { $svn_envpath/$svn_repo_name:
    ensure  => directory,
    owner   => 'apache',
    group   => 'apache',
    mode    => '0664',
    recurse => true,
    require => Exec['svnadmin_create'],
  }
  exec { 'svn_user':
    command => "htpasswd -c -b ${svn_envpath}/users ${svn_admin} ${svn_admin_pass}",
    unless  => "cat ${svn_envpath}/users | grep ${svn_admin}",
    require => Exec['svnadmin_create'],
  }
  exec { 'another_svn_user':
    command => "htpasswd -b ${svn_envpath}/users ${svn_user} ${svn_user_pass}",
    unless  => "cat ${svn_envpath}/users | grep ${svn_user}",
    require => Exec['svnadmin_create'],
    notify  => Service['httpd'],
  }
}