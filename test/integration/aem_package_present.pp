aem_package { 'Install package':
  ensure    => present,
  name      => 'somepackage',
  version   => '1.2.3',
  group     => 'somepackagegroup',
  path      => '/tmp/shinesolutions/puppet-aem-resources/',
  replicate => true,
  activate  => false,
  force     => true,
}
