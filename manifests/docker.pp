class superbuilds::docker (
) {

  include docker

#  user { 'ec2-user':
#    ensure           => 'present',
#    groups           => 'docker',
#    require          => Package['docker'],
#  }
}
