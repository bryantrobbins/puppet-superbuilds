class superbuilds::nodejs (
) {

  class { 'nodejs':
    repo_url_suffix => '5.x',
  }
}
