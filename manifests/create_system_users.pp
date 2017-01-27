class aem_resources::create_system_users(
) {

  aem_user { 'Create user - orchestrator':
    ensure   => present,
    name     => 'orchestrator',
    path     => '/home/users/o',
    password => 'orchestrator'
  }

  aem_user { 'Create user - replicator':
    ensure   => present,
    name     => 'replicator',
    path     => '/home/users/r',
    password => 'replicator'
  }

  aem_user { 'Create user - deployer':
    ensure   => present,
    name     => 'deployer',
    path     => '/home/users/d',
    password => 'deployer'
  }

  aem_user { 'Create user - exporter':
    ensure   => present,
    name     => 'exporter',
    path     => '/home/users/e',
    password => 'exporter'
  }

  aem_user { 'Create user - importer':
    ensure   => present,
    name     => 'importer',
    path     => '/home/users/i',
    password => 'importer'
  }
}
