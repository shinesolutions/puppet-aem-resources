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

$aem_system_users_change_password = {
  deployer => {
    name         => 'deployer',
    path         => '/home/users/q',
    old_password => 'customdeployerpassword',
    new_password => 'customdeployerpassword',
  },
  exporter => {
    name         => 'exporter',
    path         => '/home/users/e',
    old_password => 'customexporterpassword',
    new_password => 'customexporterpassword',
  },
  importer => {
    name         => 'importer',
    path         => '/home/users/i',
    old_password => 'customimporterpassword',
    new_password => 'customimporterpassword',
  },
  orchestrator => {
    name         => 'orchestrator',
    path         => '/home/users/o',
    old_password => 'customorchestratorpassword',
    new_password => 'customorchestratorpassword',
  },
  replicator => {
    name         => 'replicator',
    path         => '/home/users/r',
    old_password => 'customreplicatorpassword',
    new_password => 'customreplicatorpassword',
  }
}

aem_resources::create_system_users { 'Create system users with predefined password':
  aem_system_users => $aem_system_users,
} -> aem_resources::change_system_users_password { 'Update system users password with same value as original':
  aem_system_users => $aem_system_users_change_password,
}
