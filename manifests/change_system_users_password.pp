define aem_resources::change_system_users_password(
  $aem_system_users,
  $aem_username = undef,
  $aem_password = undef,
  $aem_id       = 'aem',
  $force        = true,
) {

  ensure_resources('aem_user_alias', {
    "[${aem_id}] Change user password - orchestrator" => {
      name         => $aem_system_users[orchestrator][name],
      path         => $aem_system_users[orchestrator][path],
      old_password => $aem_system_users[orchestrator][old_password],
      new_password => $aem_system_users[orchestrator][new_password],
    },
    "[${aem_id}] Change user password - replicator" => {
      name         => $aem_system_users[replicator][name],
      path         => $aem_system_users[replicator][path],
      old_password => $aem_system_users[replicator][old_password],
      new_password => $aem_system_users[replicator][new_password],
    },
    "[${aem_id}] Change user password - deployer" => {
      name         => $aem_system_users[deployer][name],
      path         => $aem_system_users[deployer][path],
      old_password => $aem_system_users[deployer][old_password],
      new_password => $aem_system_users[deployer][new_password],
    },
    "[${aem_id}] Change user password - exporter" => {
      name         => $aem_system_users[exporter][name],
      path         => $aem_system_users[exporter][path],
      old_password => $aem_system_users[exporter][old_password],
      new_password => $aem_system_users[exporter][new_password],
    },
    "[${aem_id}] Change user password - importer" => {
      name         => $aem_system_users[importer][name],
      path         => $aem_system_users[importer][path],
      old_password => $aem_system_users[importer][old_password],
      new_password => $aem_system_users[importer][new_password],
    }
  }, {
      ensure       => password_changed,
      force        => $force,
      aem_username => $aem_username,
      aem_password => $aem_password,
      aem_id       => $aem_id,
  })
}
