aem_user { 'Add user charlie to administrators group':
  ensure     => added_to_group,
  name       => 'charlie',
  path       => '/home/users/c',
  group_name => 'administrators',
  group_path => '/home/groups/a'
}
