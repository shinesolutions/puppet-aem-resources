aem_resources::author_primary_set_config { 'Set author primary config for AEM 6.3':
  aem_home_dir => '/tmp/shinesolutions/puppet-aem-resources/author-primary-6.3/',
  aem_version  => '6.3',
  aem_runmodes => ['dynamicmedia_scene7'],
  jvm_opts     => '-Dkey=value'
}
