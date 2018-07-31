define aem_resources::create_system_users(
  $aem_system_users = undef,
  $aem_username     = undef,
  $aem_password     = undef,
  $aem_id           = 'aem',
) {
  $_aem_system_users = pick(
    $aem_system_users,
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
    password     => pick($_aem_system_users[orchestrator][password], 'orchestrator'),
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
    password     => pick($_aem_system_users[replicator][password], 'replicator'),
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
    password     => pick($_aem_system_users[deployer][password], 'deployer'),
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
    password     => pick($_aem_system_users[exporter][password], 'exporter'),
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
    password     => pick($_aem_system_users[importer][password], 'importer'),
    group_name   => 'administrators',
    group_path   => '/home/groups/a',
    force        => true,
    aem_username => $aem_username,
    aem_password => $aem_password,
    aem_id       => $aem_id,
  }
}
