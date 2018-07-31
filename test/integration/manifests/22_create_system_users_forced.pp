$aem_system_users = {
  deployer => {
    name     => 'deployer',
    path     => '/home/users/q',
    password => 'customdeployerpassword',
  },
  exporter => {
    name     => 'exporter',
    path     => '/home/users/e',
    password => 'customexporterpassword',
  },
  importer => {
    name     => 'importer',
    path     => '/home/users/i',
    password => 'customimporterpassword',
  },
  orchestrator => {
    name     => 'orchestrator',
    path     => '/home/users/o',
    password => 'customorchestratorpassword',
  },
  replicator => {
    name     => 'replicator',
    path     => '/home/users/r',
    password => 'customreplicatorpassword',
  }
}

aem_resources::create_system_users { 'Create system users with predefined password':
  aem_system_users => $aem_system_users,
}
