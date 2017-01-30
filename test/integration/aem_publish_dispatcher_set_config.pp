class { 'aem_resources::publish_dispatcher_set_config':
  conf_dir     => '/tmp/puppet-aem-resources/publish/',
  docroot_dir  => '/path/to/some/docroot/',
  publish_host => 'somepublishhost',
  publish_port => 4503
}
