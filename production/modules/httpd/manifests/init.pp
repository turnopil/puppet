# Class: httpd
#
#
class httpd (
  $ssl_install = false,
  $redir_http = false,
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
