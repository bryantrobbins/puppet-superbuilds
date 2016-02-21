class superbuilds::docker (
) {

  class { '::docker': }

  user { 'ec2-user':
    ensure           => 'present',
    groups           => 'docker',
    require          => Group['docker'],
    notify           => Service['docker'],
  }

}
