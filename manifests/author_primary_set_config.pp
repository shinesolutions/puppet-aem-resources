define aem_resources::author_primary_set_config(
  $crx_quickstart_dir,
  $aem_version = '6.2',
  $start_env_file = 'start-env',
) {

  if $aem_version == '6.2' {
    $segment_package = 'org.apache.jackrabbit.oak.plugins.segment'
  }
  else {
    $segment_package = 'org.apache.jackrabbit.oak.segment'
  }

  file { "${crx_quickstart_dir}/install/${segment_package}.SegmentNodeStoreService.config":
    ensure => absent,
  }
  file { "${crx_quickstart_dir}/install/${segment_package}.standby.store.StandbyStoreService.config":
    ensure => absent,
  }

  file { "${crx_quickstart_dir}/bin":
    ensure => directory,
  }

  # work out the existing RUNMODES values
  $_file_content = file("${crx_quickstart_dir}/bin/start-env")
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

  file_line { "Set standby primary on ${crx_quickstart_dir}":
    path    => "${crx_quickstart_dir}/bin/${start_env_file}",
    line    => 'RUNMODES=\'primary\'',
    match   => '^RUNMODES=\'',
    require => File["${crx_quickstart_dir}/bin"],
  }

}
