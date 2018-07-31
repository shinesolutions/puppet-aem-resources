$aem_system_users = {
  deployer => {
    name         => 'deployer',
    path         => '/home/users/q',
    old_password => 'deployer',
    new_password => 'newdeployerpassword',
  },
  exporter => {
    name         => 'exporter',
    path         => '/home/users/e',
    old_password => 'exporter',
    new_password => 'newexporterpassword',
  },
  importer => {
    name         => 'importer',
    path         => '/home/users/i',
    old_password => 'importer',
    new_password => 'newimporterpassword',
  },
  orchestrator => {
    name         => 'orchestrator',
    path         => '/home/users/o',
    old_password => 'orchestrator',
    new_password => 'neworchestratorpassword',
  },
  replicator => {
    name         => 'replicator',
    path         => '/home/users/r',
    old_password => 'replicator',
    new_password => 'newreplicatorpassword',
  }
}

aem_resources::change_system_users_password { 'Change system users password':
  aem_system_users => $aem_system_users,
}
