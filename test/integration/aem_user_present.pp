aem_user { 'Create user':
  ensure   => present,
  name     => 'bob',
  path     => '/home/users/b',
  password => 'somepassword',
}
