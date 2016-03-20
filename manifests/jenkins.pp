class superbuilds::jenkins (
  $admin_user=hiera('superbuilds::jenkins::user'),
  $admin_password=hiera('superbuilds::jenkins::password'),
  $seed_repo=hiera('superbuilds::jenkins::seed::repo'),
  $seed_path=hiera('superbuilds::jenkins::seed::path'),
) {


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
    require      => [ Group['jenkins-group'], Package['docker'] ],
  }

  class { '::java':
    version      => '8',
  }
  
  class { '::jenkins': 
    manage_user  => false,
    manage_group => false,
    install_java => false,
    require      => [ User['jenkins-user'], Class['java'] ],
  }

  class { '::jenkins::cli_helper': }

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
  
}
