class aem_resources::change_system_users_password(
  $orchestrator_new_password,
  $replicator_new_password,
  $deployer_new_password,
  $exporter_new_password,
  $importer_new_password,
  $orchestrator_old_password = 'orchestrator',
  $replicator_old_password = 'replicator',
  $deployer_old_password = 'deployer',
  $exporter_old_password = 'exporter',
  $importer_old_password = 'importer',
) {

  aem_user { 'Change user password - orchestrator':
    ensure       => password_changed,
    name         => 'orchestrator',
    path         => '/home/users/o',
    old_password => $orchestrator_old_password,
    new_password => $orchestrator_new_password,
  }

  aem_user { 'Change user password - replicator':
    ensure       => password_changed,
    name         => 'replicator',
    path         => '/home/users/r',
    old_password => $replicator_old_password,
    new_password => $replicator_new_password,
  }

  aem_user { 'Change user password - deployer':
    ensure       => password_changed,
    name         => 'deployer',
    path         => '/home/users/q',
    old_password => $deployer_old_password,
    new_password => $deployer_new_password,
  }

  aem_user { 'Change user password - exporter':
    ensure       => password_changed,
    name         => 'exporter',
    path         => '/home/users/e',
    old_password => $exporter_old_password,
    new_password => $exporter_new_password,
  }

  aem_user { 'Change user password - importer':
    ensure       => password_changed,
    name         => 'importer',
    path         => '/home/users/i',
    old_password => $importer_old_password,
    new_password => $importer_new_password,
  }

}
