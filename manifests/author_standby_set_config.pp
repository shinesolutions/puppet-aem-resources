define aem_resources::author_standby_set_config(
  $primary_host,
  $aem_home_dir       = undef,
  $aem_id             = 'aem',
  $aem_user           = 'aem',
  $aem_user_group     = 'aem',
  $aem_version        = '6.2',
  $crx_quickstart_dir = undef,
  $osgi_configs       = undef,
  $start_env_file     = 'start-env'
) {
  if $crx_quickstart_dir {
    $_crx_quickstart_dir = $crx_quickstart_dir
  } else {
    $_crx_quickstart_dir = "${aem_home_dir}/crx-quickstart"
  }


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

  aem_resources::set_osgi_config {'Author-Standby set OSGI configuration':
    aem_home_dir   => $aem_home_dir,
    aem_user       => $aem_user,
    aem_user_group => $aem_user_group,
    aem_id         => $aem_id,
    osgi_configs   => $_osgi_configs
  }

  file { "${_crx_quickstart_dir}/bin":
    ensure => directory,
  }

  # work out the existing RUNMODES values
  $_file_content = file("${_crx_quickstart_dir}/bin/${start_env_file}")
  $_run_modes = $_file_content.match(/^RUNMODES=\'(.*)\'$/)[1]

  # set or append 'standby' to run modes
  if ($_run_modes == '') {
    $run_modes = 'standby'
  } else {
    $run_modes = "${_run_modes},standby"
  }

  file_line { "Set standby runmode on ${_crx_quickstart_dir}":
    path    => "${_crx_quickstart_dir}/bin/${start_env_file}",
    line    => "RUNMODES=\'${run_modes}\'",
    match   => '^RUNMODES=\'',
    require => File["${_crx_quickstart_dir}/bin"],
  }

}
