class superbuilds::docker (
) {

  class { '::docker': }

  user { 'ec2-user':
    ensure           => 'present',
    groups           => 'docker',
    require          => Package['docker'],
    notify           => Service['docker'],
  }
}
