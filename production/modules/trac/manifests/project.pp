# Class: trac::instance
#
#
class trac::project {
  Exec {
    path => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
  }
  file { ['/var/trac', '/var/trac/trac_projects']:
    ensure => directory,
    owner  => 'apache',
    group  => 'apache',
    mode   => '0664',
  }
  exec { 'trac_create_project':
    command => 'trac-admin /var/trac/trac_projects/svn initenv \'svn\' mysql://trac:Pr0m#t3uS@10.128.130.20:3306/test',
    unless  => 'test -d "/var/trac/trac_projects/svn"',
    require => [File['/var/trac'], Class['trac']],
  }
  file { '/var/trac/trac_projects/svn':
    ensure  => directory,
    owner   => 'apache',
    group   => 'apache',
    mode    => '0664',
    recurse => true,
    require => Exec['trac_create_project'],
  }
  exec { 'trac_deploy_project':
    command => 'trac-admin /var/trac/trac_projects/svn deploy /var/trac/trac_projects/svn',
    unless  => 'test -d "/var/trac/trac_projects/svn/cgi-bin"',
    require => File['/var/trac/trac_projects/svn'],
  }
  file { '/var/trac/trac_projects/svn/cgi-bin/trac.wsgi':
    ensure  => present,
    source  => 'puppet:///modules/trac/trac.wsgi',
    owner   => 'apache',
    group   => 'apache',
    mode    => '0644',
    require => Exec['trac_deploy_project'],
  }
  file { '/var/trac/trac_projects/svn/conf/trac.ini':
    ensure  => present,
    source  => 'puppet:///modules/trac/trac.ini',
    owner   => 'apache',
    group   => 'apache',
    mode    => '0644',
    require => Exec['trac_deploy_project'],
  }
  file { '/etc/httpd/conf.d/trac.conf':
    ensure  => file,
    source  => 'puppet:///modules/trac/trac.conf',
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
    command => 'htpasswd -c -b /var/trac/users/htpasswd vchernov vchernov',
    unless  => 'cat /var/trac/users/htpasswd | grep vchernov',
    require => File['/var/trac/users'],
  }
  exec { 'another_trac_user':
    command => 'htpasswd -b /var/trac/users/htpasswd vboyko vboyko',
    unless  => 'cat /var/trac/users/htpasswd | grep vboyko',
    require => Exec['trac_user'],
    notify  => Service['httpd'],
  }
}

