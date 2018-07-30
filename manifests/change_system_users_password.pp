define aem_resources::change_system_users_password(
  $aem_system_users,
  $credentials_hash,
  $orchestrator_old_password = 'orchestrator',
  $replicator_old_password = 'replicator',
  $deployer_old_password = 'deployer',
  $exporter_old_password = 'exporter',
  $importer_old_password = 'importer',
  $aem_username = undef,
  $aem_password = undef,
  $aem_id = 'aem',
) {

  aem_user { "[${aem_id}] Change user password - orchestrator":
    ensure       => password_changed,
    name         => $aem_system_users[orchestrator][name],
    path         => $aem_system_users[orchestrator][path],
    old_password => $orchestrator_old_password,
    new_password => $credentials_hash[orchestrator],
    aem_username => $aem_username,
    aem_password => $aem_password,
    aem_id       => $aem_id,
  }

  aem_user { "[${aem_id}] Change user password - replicator":
    ensure       => password_changed,
    name         => $aem_system_users[replicator][name],
    path         => $aem_system_users[replicator][path],
    old_password => $replicator_old_password,
    new_password => $credentials_hash[replicator],
    aem_username => $aem_username,
    aem_password => $aem_password,
    aem_id       => $aem_id,
  }

  aem_user { "[${aem_id}] Change user password - deployer":
    ensure       => password_changed,
    name         => $aem_system_users[deployer][name],
    path         => $aem_system_users[deployer][path],
    old_password => $deployer_old_password,
    new_password => $credentials_hash[deployer],
    aem_username => $aem_username,
    aem_password => $aem_password,
    aem_id       => $aem_id,
  }

  aem_user { "[${aem_id}] Change user password - exporter":
    ensure       => password_changed,
    name         => $aem_system_users[exporter][name],
    path         => $aem_system_users[exporter][path],
    old_password => $exporter_old_password,
    new_password => $credentials_hash[exporter],
    aem_username => $aem_username,
    aem_password => $aem_password,
    aem_id       => $aem_id,
  }

  aem_user { "[${aem_id}] Change user password - importer":
    ensure       => password_changed,
    name         => $aem_system_users[importer][name],
    path         => $aem_system_users[importer][path],
    old_password => $importer_old_password,
    new_password => $credentials_hash[importer],
    aem_username => $aem_username,
    aem_password => $aem_password,
    aem_id       => $aem_id,
  }

}
