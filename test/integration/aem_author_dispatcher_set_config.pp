class { 'aem_resources::author_dispatcher_set_config':
  conf_dir    => '/tmp/author/',
  docroot_dir => '/path/to/some/docroot/',
  author_host => 'someauthorhost',
  author_port => 4502
}
