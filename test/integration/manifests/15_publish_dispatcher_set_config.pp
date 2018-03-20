aem_resources::publish_dispatcher_set_config { 'Set publish-dispatcher config':
  dispatcher_conf_dir => '/tmp/shinesolutions/puppet-aem-resources/publish-dispatcher/',
  apache_conf_dir     => '/tmp/shinesolutions/puppet-aem-resources/publish-httpd/',
  docroot_dir         => '/path/to/some/docroot/',
  allowed_client      => '*.*.*.*',
  publish_host        => 'somepublishhost',
  publish_port        => 4503,
  publish_secure      => 1,
  ssl_cert            => '/etc/ssl/aem.unified-dispatcher.cert
}
