class superbuilds::docker (
) {

  class { '::docker': }

  user { 'ec2-user':
    ensure           => 'present',
    groups           => 'docker',
    require          => Package['docker'],
    notify           => Service['docker'],
  }

  user { 'ec2-user':
    ensure           => 'present',
    groups           => 'docker',
    require          => Group['docker'],
    notify           => Service['docker'],
  }

  user { 'jenkins':
    ensure           => 'present',
    groups           => 'docker',
    require          => Group['docker'],
    notify           => Service['docker'],
  }
}
