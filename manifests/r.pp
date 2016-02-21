class superbuilds::r (
) {

  package { 'R-core':
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
