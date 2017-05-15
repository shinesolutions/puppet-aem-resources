aem_group { 'Create group':
  ensure => present,
  name   => 'somegroup',
  path   => '/home/groups/s/',
}

aem_group { 'Create intern group':
  ensure => present,
  name   => 'intern',
  path   => '/home/groups/i/',
}

aem_group { 'Create staff group and add intern group as a member':
  ensure            => present,
  name              => 'staff',
  path              => '/home/groups/s',
  member_group_name => 'intern',
  member_group_path => '/home/groups/i',
  force             => true,
}

aem_group { 'Create contractor group as a member of staff group':
  ensure            => present,
  name              => 'contractor',
  path              => '/home/groups/c',
  parent_group_name => 'staff',
  parent_group_path => '/home/groups/s',
  force             => true,
}
