class aem_resources::author_standby_set_config(
  $install_dir,
  $primary_host,
) {

  file { "${install_dir}":
    ensure => directory,
  }

  file { "${install_dir}/org.apache.jackrabbit.oak.plugins.segment.SegmentNodeStoreService.config":
    ensure  => present,
    source  => 'puppet:///modules/aem_resources/org.apache.jackrabbit.oak.plugins.segment.SegmentNodeStoreService.config',
    mode    => '0664',
    require => File["${install_dir}"],
  }

  file { "${install_dir}/org.apache.jackrabbit.oak.plugins.segment.standby.store.StandbyStoreService.config":
    ensure  => file,
    content => epp('aem_resources/org.apache.jackrabbit.oak.plugins.segment.standby.store.StandbyStoreService.config.epp', { primary_host => "${primary_host}" }),
    mode    => '0664',
    require => File["${install_dir}"],
  }

}
