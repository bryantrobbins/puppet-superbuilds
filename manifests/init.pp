# == Class: superbuilds
#
# Full description of class superbuilds here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Examples
#
#  class { superbuilds:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ]
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2011 Your name here, unless otherwise noted.
#
class superbuilds (
) {

  user { 'jenkinsworker':
    ensure           => 'present',
    managehome       => true,
  }

  ssh_keygen { 'jenkinsworker':
    require          => User['jenkinsworker'],
  }

  file { '/usr/lib/jenkins/jenkins-bootstrap.sh':
    ensure           => file,
    content          => template('superbuilds/setadmin.erb'),
    require          => Ssh_keygen['jenkinsworker'],
  }

  exec { '/usr/lib/jenkins/jenkins-bootstap.sh':
    require          => File['/usr/lib/jenkins/jenkins-bootstrap.sh'], 
  }

  class { 'jenkins':
    install_java     => true,
    cli              => true,
    cli_ssh_keyfile  => '/home/jenkinsworker/.ssh/id_rsa',
    require          => Exec['/usr/lib/jenkins/jenkins-bootstrap.sh'],
  }
}
