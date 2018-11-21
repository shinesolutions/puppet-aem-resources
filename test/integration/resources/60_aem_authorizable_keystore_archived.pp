aem_authorizable_keystore { 'Archive keystore for user authentication-service':
  ensure            => archived,
  authorizable_id   => 'authentication-service',
  intermediate_path => '/home/users/system',
  path              => '/tmp/shinesolutions/puppet-aem-resources',
}
