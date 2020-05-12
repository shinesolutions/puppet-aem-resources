define aem_resources::author_standby_set_config(
  $aem_home_dir,
  $primary_host,
  $aem_context_root      = undef,
  $aem_crx_packages      = undef,
  $aem_debug_port        = undef,
  $aem_id                = 'aem',
  $aem_runmodes          = [],
  $aem_port              = '4502',
  $aem_user              = 'aem',
  $aem_user_group        = 'aem',
  $aem_version           = '6.2',
  $enable_sample_content = false,
  $jvm_mem_opts          = '-Xmx1024m',
  $jvm_opts              = undef,
  $osgi_configs          = undef,
) {
  if $osgi_configs {
    $_osgi_configs = $osgi_configs
  } else {
    if $aem_version == '6.2' {
      $_osgi_configs = {
        'org.apache.jackrabbit.oak.plugins.segment.SegmentNodeStoreService' => {
          'org.apache.sling.installer.configuration.persist' => false,
          'name'                                             => 'Oak-Tar',
          'service.ranking'                                  => 100,
          'standby'                                          => true,
          'customBlobStore'                                  => false
        },
        'org.apache.jackrabbit.oak.plugins.segment.standby.store.StandbyStoreService' => {
          'org.apache.sling.installer.configuration.persist' => false,
          'mode'                                             => 'standby',
          'primary.host'                                     => $primary_host,
          'port'                                             => 8023,
          'secure'                                           => true,
          'interval'                                         => 5
        }
      }
    } else {
      $_osgi_configs = {
        'org.apache.jackrabbit.oak.segment.SegmentNodeStoreService' => {
          'org.apache.sling.installer.configuration.persist' => false,
          'name'                                             => 'Oak-Tar',
          'service.ranking'                                  => 100,
          'standby'                                          => true,
          'customBlobStore'                                  => true
        },
        'org.apache.jackrabbit.oak.segment.standby.store.StandbyStoreService' => {
          'org.apache.sling.installer.configuration.persist' => false,
          'mode'                                             => 'standby',
          'primary.host'                                     => $primary_host,
          'port'                                             => 8023,
          'secure'                                           => true,
          'interval'                                         => 5
        },
        'org.apache.jackrabbit.oak.plugins.blob.datastore.FileDataStore' => {
          'org.apache.sling.installer.configuration.persist' => false,
          'path'                                             => './crx-quickstart/repository/datastore',
          'minRecordLength'                                  => 16384
        }
      }
    }
  }

  if !('standby' in $aem_runmodes) {
    $_runmodes = concat(['standby'], $aem_runmodes)
  } else {
    $_runmodes = $aem_runmodes
  }

  aem::config { 'Configure AEM Author-Standby':
    context_root   => $aem_context_root,
    debug_port     => $aem_debug_port,
    group          => $aem_user_group,
    home           => $aem_home_dir,
    jvm_mem_opts   => $jvm_mem_opts,
    jvm_opts       => $jvm_opts,
    osgi_configs   => $_osgi_configs,
    crx_packages   => $aem_crx_packages,
    port           => $aem_port,
    runmodes       => $_runmodes,
    sample_content => $enable_sample_content,
    type           => $aem_id,
    user           => $aem_user_group
  }
}
