class { 'aem_resources::puppet_aem_resources_set_config':
  conf_dir => '/tmp/shinesolutions/puppet-aem-resources/',
  username => 'admin',
  protocol => 'http',
  host     => 'localhost',
  port     => 4502,
  debug    => false,
}
