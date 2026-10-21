aem_resources::publish_set_config { 'Set Publish config':
  aem_home_dir => '/tmp/shinesolutions/puppet-aem-resources/publish',
  aem_runmodes => ['dynamicmedia_scene7'],
  jvm_opts     => '-Dkey=value'
}
