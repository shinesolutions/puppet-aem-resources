define aem_resources::author_primary_set_config(
  $crx_quickstart_dir,
) {

  file { "${crx_quickstart_dir}/install/org.apache.jackrabbit.oak.plugins.segment.SegmentNodeStoreService.config":
    ensure => absent,
  }
  file { "${crx_quickstart_dir}/install/org.apache.jackrabbit.oak.plugins.segment.standby.store.StandbyStoreService.config":
    ensure => absent,
  }

  file { "${crx_quickstart_dir}/bin":
    ensure => directory,
  }
  file_line { "Set standby primary on ${crx_quickstart_dir}":
    path    => "${crx_quickstart_dir}/bin/start-env",
    line    => 'RUNMODES=\'primary\'',
    match   => 'RUNMODES=\'\'',
    require => File["${crx_quickstart_dir}/bin"],
  }

}
