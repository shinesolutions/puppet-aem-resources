aem_resources::set_osgi_config { 'Set OSGI configuration':
  ensure       => 'present',
  aem_home_dir => '/tmp/shinesolutions/puppet-aem-resources/author-primary-6.2',
  osgi_configs => {
    'org.apache.jackrabbit.oak.plugins.segment.SegmentNodeStoreService'           => {
      'org.apache.sling.installer.configuration.persist' => false,
      'name'                                             => 'Oak-Tar',
      'service.ranking'                                  => 100,
      'standby'                                          => false,
      'customBlobstore'                                  => true
    },
    'org.apache.jackrabbit.oak.plugins.segment.standby.store.StandbyStoreService' => {
      'org.apache.sling.installer.configuration.persist' => false,
      'mode'                                             => 'primary',
      'port'                                             => 8023,
      'secure'                                           => true,
      'interval'                                         => 5
    }
  }
}
