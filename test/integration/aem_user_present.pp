aem_user { 'Create user bob and add to administrators group':
  ensure     => present,
  name       => 'bob',
  path       => '/home/users/b',
  password   => 'somepassword',
  group_name => 'administrators',
  group_path => '/home/groups/a',
}

aem_user { 'Create user charlie without any group':
  ensure     => present,
  name       => 'charlie',
  path       => '/home/users/c',
  password   => 'somepassword',
}
