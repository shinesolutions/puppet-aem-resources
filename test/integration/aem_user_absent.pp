aem_user { 'Delete user':
  ensure => absent,
  name   => 'bob',
  path   => '/home/users/b',
}
