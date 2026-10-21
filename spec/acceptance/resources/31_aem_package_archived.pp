aem_package { 'Archive package':
  ensure  => archived,
  name    => 'somearchivedpackage',
  version => '1.2.3',
  group   => 'somepackagegroup',
  path    => '/tmp/shinesolutions/puppet-aem-resources/',
  filter  => '[{"root":"/apps/geometrixx","rules":[]},{"root":"/apps/geometrixx-common","rules":[]}]'
}
