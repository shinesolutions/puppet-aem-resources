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

  ensure_resources('aem_user', {
    "[${aem_id}] Create user - orchestrator" => {
      name     => $_aem_system_users[orchestrator][name],
      path     => $_aem_system_users[orchestrator][path],
      password => pick($_aem_system_users[orchestrator][password], 'orchestrator'),
    },
    "[${aem_id}] Create user - replicator" => {
      name     => $_aem_system_users[replicator][name],
      path     => $_aem_system_users[replicator][path],
      password => pick($_aem_system_users[replicator][password], 'replicator'),
    },
    "[${aem_id}] Create user - deployer" => {
      name     => $_aem_system_users[deployer][name],
      path     => $_aem_system_users[deployer][path],
      password => pick($_aem_system_users[deployer][password], 'deployer'),
    },
    "[${aem_id}] Create user - exporter" => {
      name     => $_aem_system_users[exporter][name],
      path     => $_aem_system_users[exporter][path],
      password => pick($_aem_system_users[exporter][password], 'exporter'),
    },
    "[${aem_id}] Create user - importer" => {
      name     => $_aem_system_users[importer][name],
      path     => $_aem_system_users[importer][path],
      password => pick($_aem_system_users[importer][password], 'importer'),
    }
  }, {
      ensure       => present,
      group_name   => 'administrators',
      group_path   => '/home/groups/a',
      force        => true,
      aem_username => $aem_username,
      aem_password => $aem_password,
      aem_id       => $aem_id,
  })
}
