# Class: trac::instance
#
#
class trac::project {
Exec {
  path => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
}
  $db_type = $trac::db_type
  $fulldbpath = $trac::fulldbpath
  $trac_project_name = $trac::trac_project_name
  $trac_envpath = $trac::trac_envpath
  $svn_repo_name = $trac::svn_repo_name
  $trac_admin = $trac::trac_admin
  $trac_admin_pass = $trac::trac_admin_pass
  $trac_user = $trac::trac_user
  $trac_user_pass = $trac::trac_user_pass

    if ($db_type == 'mysql') {
      $db_uri = $fulldbpath
    } elsif ($db_type == 'sqlite') {
      $db_uri = 'sqlite:db/trac.db'
    }

  file { ['/var/trac', $trac_envpath]:
    ensure => directory,
    owner  => 'apache',
    group  => 'apache',
    mode   => '0664',
  }
  exec { 'trac_create_project':
    command => "trac-admin ${trac_envpath}/${trac_project_name} initenv \'${trac_project_name}\' ${db_uri}",
    unless  => "test -d \"${trac_envpath}/${trac_project_name}\"",
    require => [File['/var/trac'], Class['trac']],
  }
  file { "$trac_envpath/$trac_project_name":
    ensure  => directory,
    owner   => 'apache',
    group   => 'apache',
    mode    => '0664',
    recurse => true,
    require => Exec['trac_create_project'],
  }
  exec { 'trac_deploy_project':
    command => "trac-admin ${trac_envpath}/${trac_project_name} deploy ${trac_envpath}/${trac_project_name}",
    unless  => "test -d \"${trac_envpath}/${trac_project_name}/cgi-bin\"",
    require => File["$trac_envpath/$trac_project_name"],
  }
  file { "${trac_envpath}/${trac_project_name}/cgi-bin/trac.wsgi":
    ensure  => present,
    content => template('trac/trac.wsgi.erb'),
    owner   => 'apache',
    group   => 'apache',
    mode    => '0644',
    require => Exec['trac_deploy_project'],
  }
  file { "${trac_envpath}/${trac_project_name}/conf/trac.ini":
    ensure  => present,
    content => template('trac/trac.ini.erb'),
    owner   => 'apache',
    group   => 'apache',
    mode    => '0644',
    require => Exec['trac_deploy_project'],
  }
  file { '/etc/httpd/conf.d/trac.conf':
    ensure  => file,
    content => template('trac/trac.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Exec['trac_deploy_project'],
    #notify  => Service['httpd'],
  }
  file { '/var/trac/users':
    ensure  => directory,
    owner   => 'apache',
    group   => 'apache',
    mode    => '0664',
    require => File['/etc/httpd/conf.d/trac.conf'],
  }
  exec { 'trac_user':
    command => "htpasswd -c -b /var/trac/users/htpasswd ${trac_admin} ${trac_admin_pass}",
    unless  => "cat /var/trac/users/htpasswd | grep ${trac_admin}",
    require => File['/var/trac/users'],
  }
  exec { 'another_trac_user':
    command => "htpasswd -b /var/trac/users/htpasswd ${trac_user} ${trac_user_pass}",
    unless  => "cat /var/trac/users/htpasswd | grep ${trac_user}",
    require => Exec['trac_user'],
    notify  => Service['httpd'],
  }
}

