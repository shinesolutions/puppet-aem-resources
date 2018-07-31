aem_resources::author_dispatcher_set_config { 'Set author-dispatcher config':
  dispatcher_conf_dir => '/tmp/shinesolutions/puppet-aem-resources/author-dispatcher/',
  virtual_hosts_dir   => '/tmp/shinesolutions/puppet-aem-resources/author-virtual-hosts/',
  docroot_dir         => '/path/to/some/docroot/',
  author_host         => 'someauthorhost',
  author_port         => 4502,
  author_secure       => 1,
  ssl_cert            => '/etc/ssl/aem.unified-dispatcher.cert'
}
