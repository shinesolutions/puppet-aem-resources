aem_authorizable_keystore { 'Create new keystore for user authentication-service':
  ensure            => present,
  authorizable_id   => 'authentication-service',
  intermediate_path => '/home/users/system',
  password          => 'somekeystorepassword',
}
