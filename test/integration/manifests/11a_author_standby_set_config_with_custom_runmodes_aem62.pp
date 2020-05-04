aem_resources::author_standby_set_config { 'Set author standby config for AEM 6.2 (default) with existing custom run modes':
  aem_home_dir   => '/tmp/shinesolutions/puppet-aem-resources/author-standby-6.2',
  primary_host   => 'somehost',
  start_env_file => 'start-env-with-multi',
}
