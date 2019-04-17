aem_resources::author_standby_set_config { 'Set author standby config for AEM 6.2 (default) with existing custom run modes':
  crx_quickstart_dir => '/tmp/shinesolutions/puppet-aem-resources/author-standby-6.2/',
  primary_host       => 'somehost',
  start_env_file     => 'start-env-with-multi',
}

aem_resources::author_standby_set_config { 'Set author standby config for AEM 6.3 with existing custom run modes':
  crx_quickstart_dir => '/tmp/shinesolutions/puppet-aem-resources/author-standby-6.3/',
  primary_host       => 'somehost',
  aem_version        => '6.3',
  start_env_file     => 'start-env-with-multi',
}
