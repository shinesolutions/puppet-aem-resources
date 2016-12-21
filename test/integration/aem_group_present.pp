aem_group { 'Create group':
  ensure => present,
  name   => 'somegroup',
  path   => '/home/groups/s/',
}
