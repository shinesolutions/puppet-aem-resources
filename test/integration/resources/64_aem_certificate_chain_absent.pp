aem_certificate_chain { 'Remove certificate from keystore for user authentication-service':
  ensure            => absent,
  authorizable_id   => 'authentication-service',
  intermediate_path => '/home/users/system',
  private_key_alias => 'somealias',
}
