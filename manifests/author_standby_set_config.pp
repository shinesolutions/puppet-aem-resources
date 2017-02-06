class aem_resources::author_standby_set_config(
  $crx_quickstart_dir,
  $primary_host,
) {

  file { "${crx_quickstart_dir}/install":
    ensure => directory,
  }
  file { "${crx_quickstart_dir}/install/org.apache.jackrabbit.oak.plugins.segment.SegmentNodeStoreService.config":
    ensure  => present,
    source  => 'puppet:///modules/aem_resources/org.apache.jackrabbit.oak.plugins.segment.SegmentNodeStoreService.config',
    mode    => '0664',
    require => File["${crx_quickstart_dir}/install"],
  }
  file { "${crx_quickstart_dir}/install/org.apache.jackrabbit.oak.plugins.segment.standby.store.StandbyStoreService.config":
    ensure  => file,
    content => epp('aem_resources/org.apache.jackrabbit.oak.plugins.segment.standby.store.StandbyStoreService.config.epp', { primary_host => "${primary_host}" }),
    mode    => '0664',
    require => File["${crx_quickstart_dir}/install"],
  }

  file { "${crx_quickstart_dir}/bin":
    ensure => directory,
  }
  file_line { 'Set standby runmode':
    path    => "${crx_quickstart_dir}/bin/start-env",
    line    => 'RUNMODES=\'standby\'',
    match   => 'RUNMODES=\'\'',
    require => File["${crx_quickstart_dir}/bin"],
  }

}
