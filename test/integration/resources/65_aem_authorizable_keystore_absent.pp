aem_authorizable_keystore { 'Delete keystore for user authentication-service':
  ensure            => absent,
  authorizable_id   => 'authentication-service',
  intermediate_path => '/home/users/system',
}
