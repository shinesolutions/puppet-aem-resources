define aem_resources::author_primary_set_config(
  $crx_quickstart_dir,
  $aem_version = '6.2',
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

  # set or append 'primary' to run modes
  if ($_run_modes == '') {
    $run_modes = "\'primary\'"
  } else {
    $run_modes = "\'${_run_modes},primary\'"
  }

  file_line { "Set standby primary on ${crx_quickstart_dir}":
    path    => "${crx_quickstart_dir}/bin/start-env",
    line    => "RUNMODES=${run_modes}",
    match   => "^RUNMODES=",
    require => File["${crx_quickstart_dir}/bin"],
  }

}
