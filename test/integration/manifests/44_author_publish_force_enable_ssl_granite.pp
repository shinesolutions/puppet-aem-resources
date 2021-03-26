aem_resources::author_publish_enable_ssl { 'Enable author/publish SSL via Granite':
  run_mode            => 'author',
  aem_id              => 'author',
  ssl_method          => 'granite',
  force               => true,
  port                => 5435,
  keystore            => '/tmp/shinesolutions/puppet-aem-resources/cert_ssl2.der',
  keystore_password   => 'somekeystorepassword',
  truststore          => '/tmp/shinesolutions/puppet-aem-resources/cert_ssl2.crt',
  truststore_password => 'sometruststorepassword',
}
