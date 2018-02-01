aem_resources::author_standby_set_config { 'Set author standby config for AEM 6.2 (default)':
  crx_quickstart_dir => '/tmp/shinesolutions/puppet-aem-resources/author-standby-6.2/',
  primary_host       => 'somehost',
}

aem_resources::author_standby_set_config { 'Set author standby config for AEM 6.3':
  crx_quickstart_dir => '/tmp/shinesolutions/puppet-aem-resources/author-standby-6.3/',
  primary_host       => 'somehost',
  aem_version        => '6.3',
}
