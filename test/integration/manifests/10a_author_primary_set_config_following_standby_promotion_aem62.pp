aem_resources::author_primary_set_config { 'Set author primary config for AEM 6.2 with existing standby following promotion':
  aem_home_dir   => '/tmp/shinesolutions/puppet-aem-resources/author-primary-6.2/',
  aem_version    => '6.2',
  start_env_file => 'start-env-with-standby',
}
