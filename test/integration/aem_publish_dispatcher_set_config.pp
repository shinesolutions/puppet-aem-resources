class { 'aem_resources::publish_dispatcher_set_config':
  dispatcher_conf_dir => '/tmp/puppet-aem-resources/publish-dispatcher/',
  httpd_conf_dir      => '/tmp/puppet-aem-resources/publish-httpd/',
  docroot_dir         => '/path/to/some/docroot/',
  publish_host        => 'somepublishhost',
  publish_port        => 4503,
}
