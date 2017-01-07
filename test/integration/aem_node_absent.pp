aem_node { 'Delete http OSGI config node':
  ensure => absent,
  name   => 'org.apache.felix.http',
  path   => '/apps/system/config.author',
}
