class superbuilds::hubot (
) {

  package { 'hubot':
    ensure   => 'present',
    provider => 'npm',
  }

  package { 'coffee-script':
    ensure   => 'present',
    provider => 'npm',
  }

  package { 'yo':
    ensure   => 'present',
    provider => 'npm',
  }

  package { 'generator-hubot':
    ensure   => 'present',
    provider => 'npm',
  }

}
