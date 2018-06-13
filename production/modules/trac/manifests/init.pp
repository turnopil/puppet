# Class: trac
#
#
class trac {

  package { 'trac':
    ensure  => installed,
    require => Package['epel-release'],
  }
  include trac::conf
  #include trac::python
  include trac::project
}