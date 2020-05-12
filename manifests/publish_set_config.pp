define aem_resources::publish_set_config(
  $aem_home_dir,
  $aem_context_root      = undef,
  $aem_crx_packages      = undef,
  $aem_debug_port        = undef,
  $aem_id                = 'aem',
  $aem_runmodes          = [],
  $aem_port              = '4503',
  $aem_user              = 'aem',
  $aem_user_group        = 'aem',
  $enable_sample_content = false,
  $jvm_mem_opts          = '-Xmx1024m',
  $jvm_opts              = undef,
  $osgi_configs          = {},
) {

  aem::config { 'Configure AEM Publish':
    context_root   => $aem_context_root,
    debug_port     => $aem_debug_port,
    group          => $aem_user_group,
    home           => $aem_home_dir,
    jvm_mem_opts   => $jvm_mem_opts,
    jvm_opts       => $jvm_opts,
    osgi_configs   => $osgi_configs,
    crx_packages   => $aem_crx_packages,
    port           => $aem_port,
    runmodes       => $aem_runmodes,
    sample_content => $enable_sample_content,
    type           => $aem_id,
    user           => $aem_user_group
  }
}
