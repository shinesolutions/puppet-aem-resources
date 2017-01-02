aem_user { 'Change user password':
  ensure       => password_changed,
  name         => 'bob',
  path         => '/home/users/b',
  old_password => 'someoldpassword',
  new_password => 'somenewpassword'
}
