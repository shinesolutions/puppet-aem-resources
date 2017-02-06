class { 'aem_resources::puppet_aem_resources_set_config':
  conf_dir => '/tmp/puppet-aem-resources/',
  protocol => 'http',
  host     => 'localhost',
  port     => 4502,
  debug    => false,
}
