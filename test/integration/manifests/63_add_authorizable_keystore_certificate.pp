aem_resources::add_authorizable_keystore_certificate { 'Add certificate chain to authorizable keystore':
  authorizable_id             => 'authentication-service',
  intermediate_path           => '/home/users/system',
  certificate_chain_file_path => '/tmp/shinesolutions/puppet-aem-resources/cert_chain.crt',
  private_key_file_path       => '/tmp/shinesolutions/puppet-aem-resources/private_key.der',
  private_key_alias           => 'somealias',
}
