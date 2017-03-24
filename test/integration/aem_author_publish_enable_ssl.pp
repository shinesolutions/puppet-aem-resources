class { 'aem_resources::author_publish_enable_ssl':
  run_mode                => 'author',
  port                    => 5433,
  ssl_dir                 => '/tmp/shinesolutions/puppet-aem-resources/author-primary/',
  keystore_cert           => '/tmp/shinesolutions/puppet-aem-resources/aem.cert',
  keystore_password       => 'somekeystorepassword',
  keystore_key_alias      => 'cqse',
  keystore_private_key    => '/tmp/shinesolutions/puppet-aem-resources/aem.key',
  keystore_key_password   => 'somekeystorekeypassword',
  keystore_trustcacerts   => true,
  truststore_cert         => '/tmp/shinesolutions/puppet-aem-resources/aem.cert',
  truststore_password     => 'sometruststorepassword',
  truststore_trustcacerts => true,
}
