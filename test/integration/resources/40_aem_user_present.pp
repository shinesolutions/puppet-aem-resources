aem_user { 'Create user bob and add to administrators group':
  ensure     => present,
  name       => 'bob',
  path       => '/home/users/b',
  password   => 'somepassword',
  group_name => 'administrators',
  group_path => '/home/groups/a',
  permission => {
    '/libs' => ['read:false', 'modify:false', 'create:false', 'delete:false', 'acl_read:false', 'acl_edit:false', 'replicate:false'],
    '/var'  => ['read:false', 'modify:false', 'create:false', 'delete:false', 'acl_read:false', 'acl_edit:false', 'replicate:false'],
    '/tmp'  => ['read:false', 'modify:false', 'create:false', 'delete:false', 'acl_read:false', 'acl_edit:false', 'replicate:false'],
  },
  force      => true,
}

aem_user { 'Create user charlie without any group':
  ensure   => present,
  name     => 'charlie',
  path     => '/home/users/c',
  password => 'somepassword',
}
