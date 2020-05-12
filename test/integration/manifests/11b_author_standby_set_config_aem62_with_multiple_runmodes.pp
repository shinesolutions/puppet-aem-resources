aem_resources::author_standby_set_config { 'Set author standby config for AEM 6.2 (default)':
  aem_home_dir => '/tmp/shinesolutions/puppet-aem-resources/author-standby-6.2',
  primary_host => 'somehost',
  aem_runmodes => ['dynamicmedia_scene7']
}
