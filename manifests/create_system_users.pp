define aem_resources::create_system_users(
  $aem_system_users = undef,
  $orchestrator_password = 'orchestrator',
  $replicator_password = 'replicator',
  $deployer_password = 'deployer',
  $exporter_password = 'exporter',
  $importer_password = 'importer',
  $aem_username = undef,
  $aem_password = undef,
  $aem_id = 'aem',
) {
  $_aem_system_users = pick(
    $aem_system_users,
    admin => {
      name => 'admin',
      path => '/home/users/d'
      },
      deployer => {
      name => 'deployer',
      path => '/home/users/q'
      },
      exporter => {
      name => 'exporter',
      path => '/home/users/e'
      },
      importer => {
      name => 'importer',
      path => '/home/users/i'
      },
      orchestrator => {
      name => 'orchestrator',
      path => '/home/users/o'
      },
      replicator => {
      name => 'replicator',
      path => '/home/users/r'
              },
  )

  aem_user { "[${aem_id}] Create user - orchestrator":
    ensure       => present,
    name         => $_aem_system_users[orchestrator][name],
    path         => $_aem_system_users[orchestrator][path],
    password     => $orchestrator_password,
    group_name   => 'administrators',
    group_path   => '/home/groups/a',
    force        => true,
    aem_username => $aem_username,
    aem_password => $aem_password,
    aem_id       => $aem_id,
  }

  aem_user { "[${aem_id}] Create user - replicator":
    ensure       => present,
    name         => $_aem_system_users[replicator][name],
    path         => $_aem_system_users[replicator][path],
    password     => $replicator_password,
    group_name   => 'administrators',
    group_path   => '/home/groups/a',
    force        => true,
    aem_username => $aem_username,
    aem_password => $aem_password,
    aem_id       => $aem_id,
  }

  # deployer user does not use /home/users/d/
  # because postAuthorizables fail when the
  # intermediatePath already exists
  # (/home/users/d/ is used by admin user in
  # AEM 6.2 jar)
  # /home/users/q/ is used instead just because
  # it doesn't exist on vanilla AEM installation
  aem_user { "[${aem_id}] Create user - deployer":
    ensure       => present,
    name         => $_aem_system_users[deployer][name],
    path         => $_aem_system_users[deployer][path],
    password     => $deployer_password,
    group_name   => 'administrators',
    group_path   => '/home/groups/a',
    force        => true,
    aem_username => $aem_username,
    aem_password => $aem_password,
    aem_id       => $aem_id,
  }

  aem_user { "[${aem_id}] Create user - exporter":
    ensure       => present,
    name         => $_aem_system_users[exporter][name],
    path         => $_aem_system_users[exporter][path],
    password     => $exporter_password,
    group_name   => 'administrators',
    group_path   => '/home/groups/a',
    force        => true,
    aem_username => $aem_username,
    aem_password => $aem_password,
    aem_id       => $aem_id,
  }

  aem_user { "[${aem_id}] Create user - importer":
    ensure       => present,
    name         => $_aem_system_users[importer][name],
    path         => $_aem_system_users[importer][path],
    password     => $importer_password,
    group_name   => 'administrators',
    group_path   => '/home/groups/a',
    force        => true,
    aem_username => $aem_username,
    aem_password => $aem_password,
    aem_id       => $aem_id,
  }
}
