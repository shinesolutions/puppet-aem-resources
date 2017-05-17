aem_user { 'Change user bob password':
  ensure       => password_changed,
  name         => 'bob',
  path         => '/home/users/b',
  old_password => 'somepassword',
  new_password => 'somenewpassword'
}
