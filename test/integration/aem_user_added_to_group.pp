aem_user { 'Add user to group':
  ensure     => added_to_group,
  name       => 'bob',
  path       => '/home/users/b',
  group_name => 'administrators',
  group_path => '/home/groups/a'
}
