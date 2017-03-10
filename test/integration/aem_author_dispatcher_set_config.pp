class { 'aem_resources::author_dispatcher_set_config':
  dispatcher_conf_dir => '/tmp/shinesolution/puppet-aem-resources/author-dispatcher/',
  httpd_conf_dir      => '/tmp/shinesolution/puppet-aem-resources/author-httpd/',
  docroot_dir         => '/path/to/some/docroot/',
  author_host         => 'someauthorhost',
  author_port         => 4502,
}
