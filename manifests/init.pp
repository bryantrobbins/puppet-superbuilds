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

  include superbuilds::docker
  include superbuilds::packer
  include superbuilds::r
  include superbuilds::nodejs

  # The jenkinsworker is used by the hacky bootstrap script exec
  user { 'jenkinsworker':
    ensure           => 'present',
    managehome       => true,
  }

  ssh_keygen { 'jenkinsworker':
    require          => User['jenkinsworker'],
  }

  group { 'jenkins-group':
    name         => 'jenkins',
    ensure       => present,
  }

  user { 'jenkins-user':
    name         => 'jenkins',
    ensure       => present,
    groups       => [ 'jenkins', 'docker'],
    managehome   => false,
    home         => '/var/lib/jenkins',
    require      => Group['jenkins-group'],
  }

  class { 'jenkins': 
    manage_user  => false,
    manage_group => false,
    require      => User['jenkins-user'],
  }

  class { 'jenkins::cli_helper': }

  jenkins::plugin { 'git-client': }
  jenkins::plugin { 'ssh-credentials': }
  jenkins::plugin { 'mailer': }
  jenkins::plugin { 'promoted-builds': }
  jenkins::plugin { 'matrix-project': }
  jenkins::plugin { 'parameterized-trigger': }
  jenkins::plugin { 'token-macro': }
  jenkins::plugin { 'credentials': }
  jenkins::plugin { 'scm-api': }
  jenkins::plugin { 'git': }
  jenkins::plugin { 'job-dsl': }
  jenkins::plugin { 'ws-cleanup': }
  jenkins::plugin { 'copyartifact': }

  file { '/usr/lib/jenkins/jenkins-bootstrap.sh':
    ensure           => file,
    content          => template('superbuilds/setadmin.erb'),
    mode             => '0700',
    require          => Class['jenkins::cli_helper'],
  }

  file { '/usr/lib/jenkins/seed-job.xml':
    ensure           => file,
    content          => template('superbuilds/seed.xml.erb'),
    mode             => '0700',
    require          => Class['jenkins::cli_helper'],
  }

  exec { '/usr/lib/jenkins/jenkins-bootstrap.sh':
    creates          => '/usr/lib/jenkins/jenkins-bootstrap.done',
    require          => [ File['/usr/lib/jenkins/jenkins-bootstrap.sh'], File['/usr/lib/jenkins/seed-job.xml'] ],
  }
  
  class { 'gradle':
    version => '2.11',
  }

  package { 'jq':
    ensure => present,
  }

}
