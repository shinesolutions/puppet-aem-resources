aem_resources::author_primary_set_config { 'Set author primary config for AEM 6.2 (default)':
  crx_quickstart_dir => '/tmp/shinesolutions/puppet-aem-resources/author-primary-6.2/',
}

aem_resources::author_primary_set_config { 'Set author primary config for AEM 6.3':
  crx_quickstart_dir => '/tmp/shinesolutions/puppet-aem-resources/author-primary-6.3/',
  aem_version        => '6.3',
}
