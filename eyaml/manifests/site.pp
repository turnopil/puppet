# Class: main
#
#
class main {
package { 'tree':
	ensure => installed,
}

$filecrt = hiera_hash('files')
create_resources(file, $filecrt)
}