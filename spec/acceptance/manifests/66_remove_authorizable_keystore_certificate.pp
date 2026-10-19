aem_resources::remove_authorizable_keystore_certificate { 'Remove certificate chain to authorizable keystore':
  authorizable_id   => 'authentication-service',
  intermediate_path => '/home/users/system',
  private_key_alias => 'somealias',
}
