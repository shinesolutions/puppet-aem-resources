class aem_resources::create_system_users(
  $orchestrator_password = 'orchestrator',
  $replicator_password = 'replicator',
  $deployer_password = 'deployer',
  $exporter_password = 'exporter',
  $importer_password = 'importer',
) {

  aem_user { 'Create user - orchestrator':
    ensure     => present,
    name       => 'orchestrator',
    path       => '/home/users/o',
    password   => "${orchestrator_password}",
    group_name => 'administrators',
    group_path => '/home/groups/a',
    force      => true,
  }

  aem_user { 'Create user - replicator':
    ensure     => present,
    name       => 'replicator',
    path       => '/home/users/r',
    password   => "${replicator_password}",
    group_name => 'administrators',
    group_path => '/home/groups/a',
    force      => true,
  }

  aem_user { 'Create user - deployer':
    ensure     => present,
    name       => 'deployer',
    path       => '/home/users/d',
    password   => "${deployer_password}",
    group_name => 'administrators',
    group_path => '/home/groups/a',
    force      => true,
  }

  aem_user { 'Create user - exporter':
    ensure     => present,
    name       => 'exporter',
    path       => '/home/users/e',
    password   => "${exporter_password}",
    group_name => 'administrators',
    group_path => '/home/groups/a',
    force      => true,
  }

  aem_user { 'Create user - importer':
    ensure     => present,
    name       => 'importer',
    path       => '/home/users/i',
    password   => "${importer_password}",
    group_name => 'administrators',
    group_path => '/home/groups/a',
    force      => true,
  }
}
