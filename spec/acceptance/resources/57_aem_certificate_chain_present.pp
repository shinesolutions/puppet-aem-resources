aem_certificate_chain { 'Add certificate chain to keystore for user authentication-service':
  ensure                      => present,
  authorizable_id             => 'authentication-service',
  intermediate_path           => '/home/users/system',
  private_key_alias           => 'somealias',
  private_key_file_path       => '/tmp/shinesolutions/puppet-aem-resources/private_key.der',
  certificate_chain_file_path => '/tmp/shinesolutions/puppet-aem-resources/cert_chain.crt'
}
