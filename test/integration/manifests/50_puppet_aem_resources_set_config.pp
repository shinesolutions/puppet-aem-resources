aem_resources::puppet_aem_resources_set_config { 'Set puppet-aem-resources config file for author 1':
  conf_dir => '/tmp/shinesolutions/puppet-aem-resources/',
  username => 'admin',
  protocol => 'http',
  host     => 'localhost',
  port     => 4502,
  debug    => false,
  aem_id   => 'test-aem-author1',
}

aem_resources::puppet_aem_resources_set_config { 'Set puppet-aem-resources config file for author 2':
  conf_dir => '/tmp/shinesolutions/puppet-aem-resources/',
  username => 'admin',
  protocol => 'http',
  host     => 'localhost',
  port     => 4502,
  debug    => false,
  aem_id   => 'test-aem-author2',
}
