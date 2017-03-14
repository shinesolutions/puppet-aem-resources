class aem_resources::create_system_users(
) {

  aem_user { 'Create user - orchestrator':
    ensure     => present,
    name       => 'orchestrator',
    path       => '/home/users/o',
    password   => 'orchestrator',
    group_name => 'administrators',
    group_path => '/home/groups/a',
  }

  aem_user { 'Create user - replicator':
    ensure     => present,
    name       => 'replicator',
    path       => '/home/users/r',
    password   => 'replicator',
    group_name => 'administrators',
    group_path => '/home/groups/a',
  }

  aem_user { 'Create user - deployer':
    ensure     => present,
    name       => 'deployer',
    path       => '/home/users/d',
    password   => 'deployer',
    group_name => 'administrators',
    group_path => '/home/groups/a',
  }

  aem_user { 'Create user - exporter':
    ensure     => present,
    name       => 'exporter',
    path       => '/home/users/e',
    password   => 'exporter',
    group_name => 'administrators',
    group_path => '/home/groups/a',
  }

  aem_user { 'Create user - importer':
    ensure     => present,
    name       => 'importer',
    path       => '/home/users/i',
    password   => 'importer',
    group_name => 'administrators',
    group_path => '/home/groups/a',
  }
}
