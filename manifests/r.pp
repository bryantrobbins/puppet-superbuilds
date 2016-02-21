class superbuilds::r (
) {

  package { 'R-base':
    ensure => present,
  }
  
  package { 'R-devel':
    ensure => present,
  }
  
  package { 'openssl-devel':
    ensure => present,
  }
  
  package { 'libcurl-devel':
    ensure => present,
  }
  

}
