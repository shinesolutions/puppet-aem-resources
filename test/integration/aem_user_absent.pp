aem_user { 'Delete user bob':
  ensure => absent,
  name   => 'bob',
  path   => '/home/users/b',
}

aem_user { 'Delete user charlie':
  ensure => absent,
  name   => 'charlie',
  path   => '/home/users/c',
}
