# Class: httpd
#
#
class httpd (
  $ssl_install = true,
  $redir_http  = true,
  $filecrt     = undef,
  $filekey     = undef,
) {
  package { 'httpd':
    ensure => installed,
  }
  service { 'httpd':
    ensure  => running,
    enable  => true,
    #hasrestart => true,
    #hasstatus  => true,
    require => Package['httpd'],
  }
  if ($ssl_install) {
    include httpd::ssl
  }
}
