class aem_resources::author_set_as_standby(
  $install_dir,
  $primary_host,
) {

  file { "${install_dir}/org.apache.jackrabbit.oak.plugins.segment.SegmentNodeStoreService.config":
    ensure => present,
    source => 'puppet:///modules/aem_resources/org.apache.jackrabbit.oak.plugins.segment.SegmentNodeStoreService.config',
    mode   => '0664',
  }

  file { "${install_dir}/org.apache.jackrabbit.oak.plugins.segment.standby.store.StandbyStoreService.config":
    ensure  => file,
    content => epp('aem_resources/org.apache.jackrabbit.oak.plugins.segment.standby.store.StandbyStoreService.config.epp', { primary_host => "${primary_host}" }),
    mode    => '0664',
  }

}
