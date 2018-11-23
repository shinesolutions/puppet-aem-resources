aem_certificate { 'Export certificate by serial':
  ensure              => archived,
  serial              => '18165092276682983468',
  file                => '/tmp/shinesolutions/puppet-aem-resources/saml_exported.crt',
  truststore_password => 'sometruststorepassword'
}
