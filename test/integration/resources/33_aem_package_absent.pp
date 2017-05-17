aem_package { 'Delete package':
  ensure  => absent,
  name    => 'somepackage',
  version => '1.2.3',
  group   => 'somepackagegroup',
}
