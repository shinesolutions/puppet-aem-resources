define aem_resources::author_primary_set_config(
  $aem_home_dir       = undef,
  $aem_id             = 'aem',
  $aem_user           = 'aem',
  $aem_user_group     = 'aem',
  $aem_version        = '6.2',
  $crx_quickstart_dir = undef,
  $osgi_configs       = undef,
  $start_env_file     = 'start-env',
) {
  if $crx_quickstart_dir {
    $_crx_quickstart_dir = $crx_quickstart_dir
  } else {
    $_crx_quickstart_dir = "${aem_home_dir}/crx-quickstart"
  }

  if $aem_version == '6.2' {
    $segment_package = 'org.apache.jackrabbit.oak.plugins.segment'
  }
  else {
    $segment_package = 'org.apache.jackrabbit.oak.segment'
  }

  if $osgi_configs {
    $_osgi_configs = $osgi_configs
  }
  else {
    $_osgi_configs = {
      $segment_package => {
        'org.apache.sling.installer.configuration.persist' => false,
        'name'                                             => 'Oak-Tar',
        'service.ranking'                                  => 100,
        'standby'                                          => false,
        'customBlobstore'                                  => true
      },
      "${segment_package}.standby.store.StandbyStoreService" => {
        'org.apache.sling.installer.configuration.persist' => false,
        'mode'                                             => 'primary',
        'port'                                             => 8023,
        'secure'                                           => true,
        'interval'                                         => 5
      }
    }
  }

  aem_resources::set_osgi_config {'Author-Primary set OSGI configuration':
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

  # replace 'standby' with 'primary' if it exists
  $_temp = $_run_modes.split(',').map | $rm | {
      if $rm == 'standby' {
          'primary'
      } else {
          $rm
      }
  }

  if $_run_modes == '' {
      $run_modes = 'primary'
  } elsif 'primary' in $_temp {
      $run_modes = $_temp.join(',')
  } else {
      $run_modes = ($_temp + ['primary']).join(',')
  }

  file_line { "Set standby primary on ${_crx_quickstart_dir}":
    path    => "${_crx_quickstart_dir}/bin/${start_env_file}",
    line    => "RUNMODES=\'${run_modes}\'",
    match   => '^RUNMODES=\'',
    require => File["${_crx_quickstart_dir}/bin"],
  }

}
