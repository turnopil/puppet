# Class: httpd
#
#
class trac::conf {

  package { 'mod_wsgi':
    ensure  => installed,
    require => Package['httpd'],
  }

  $py_packages = ['MySQL-python', 'python', 'python-setuptools']
  package { $py_packages:
    ensure => installed,
    }
  exec { 'acct_mgr':
    command => 'easy_install https://trac-hacks.org/svn/accountmanagerplugin/tags/acct_mgr-0.4.4',
    path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    unless  => 'test -d "/usr/lib/python2.6/site-packages/TracAccountManager-0.4.4-py2.6.egg"',
    require => [Package['python'], Package['subversion']],
    }
}

