define aem_resources::author_standby_set_config(
  $crx_quickstart_dir,
  $primary_host,
  $aem_version = '6.2',
  $start_env_file = 'start-env',
) {

  if $aem_version == '6.2' {
    $segment_package = 'org.apache.jackrabbit.oak.plugins.segment'
  }
  else {
    $segment_package = 'org.apache.jackrabbit.oak.segment'
  }

  file { "${crx_quickstart_dir}/install":
    ensure => directory,
  }
  file { "${crx_quickstart_dir}/install/${segment_package}.SegmentNodeStoreService.config":
    ensure  => present,
    source  => 'puppet:///modules/aem_resources/SegmentNodeStoreService.config',
    mode    => '0664',
    require => File["${crx_quickstart_dir}/install"],
  }
  file { "${crx_quickstart_dir}/install/${segment_package}.standby.store.StandbyStoreService.config":
    ensure  => file,
    content => epp('aem_resources/StandbyStoreService.config.epp', { primary_host => $primary_host }),
    mode    => '0664',
    require => File["${crx_quickstart_dir}/install"],
  }

  file { "${crx_quickstart_dir}/bin":
    ensure => directory,
  }

  # work out the existing RUNMODES values
  $_file_content = file("${crx_quickstart_dir}/bin/start-env")
  $_run_modes = $_file_content.match(/^RUNMODES=\'(.*)\'$/)[1]

  # set or append 'standby' to run modes
  if ($_run_modes == '') {
    $run_modes = "\'standby\'"
  } else {
    $run_modes = "\'${_run_modes},standby\'"
  }

  file_line { "Set standby runmode on ${crx_quickstart_dir}":
    path    => "${crx_quickstart_dir}/bin/start-env",

  file_line { "Set standby runmode on ${crx_quickstart_dir}":
    path    => "${crx_quickstart_dir}/bin/${start_env_file}",
    line    => 'RUNMODES=\'standby\'',
    match   => '^RUNMODES=\'',
    require => File["${crx_quickstart_dir}/bin"],
  }

}
