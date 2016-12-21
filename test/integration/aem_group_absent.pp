aem_group { 'Delete group':
  ensure => absent,
  name   => 'somegroup',
  path   => '/home/groups/s/',
}
