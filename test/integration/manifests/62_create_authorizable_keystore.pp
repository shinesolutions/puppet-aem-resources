aem_resources::create_authorizable_keystore { 'Create authorizable Keystore':
  authorizable_id                => 'authentication-service',
  intermediate_path              => '/home/users/system',
  authorizable_keystore_password => 'somepassword'
}
