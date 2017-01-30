class { 'aem_resources::publish_dispatcher_set_config':
  conf_dir    => '/tmp/publish/',
  docroot_dir => '/path/to/some/docroot/',
  publish_host => 'somepublishhost',
  publish_port => 4503
}
