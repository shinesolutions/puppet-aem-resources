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
      path => '/home/users/q',
      permission => {
        '/apps' => ['read:true', 'modify:true', 'create:true', 'delete:true', 'acl_read:true', 'acl_edit:true', ‘replicate:false'],
        '/conf'  => ['read:true', 'modify:true', 'create:true', 'delete:true', 'acl_read:true', 'acl_edit:true', 'replicate:false'],
        '/content'  => ['read:true', 'modify:true', 'create:true', 'delete:true', 'acl_read:true', 'acl_edit:true', 'replicate:false'],
        '/etc'  => ['read:true', 'modify:true', 'create:true', 'delete:true', 'acl_read:true', 'acl_edit:true', ‘replicate:false'],
        '/home'  => ['read:true', 'modify:true', 'create:true', 'delete:true', 'acl_read:true', 'acl_edit:true', ‘replicate:false'],
        ‘/oak:index'  => ['read:true', 'modify:true', 'create:true', 'delete:true', 'acl_read:true', 'acl_edit:true', 'replicate:false'],
      },
    },
    exporter => {
      name => 'exporter',
      path => '/home/users/e',
      permission => {
        '/' => ['read:true', 'modify:false', 'create:false', 'delete:false', 'acl_read:true', 'acl_edit:false', 'replicate:false'],
        '/apps' => ['read:true', 'modify:false', 'create:false', 'delete:false', 'acl_read:true', 'acl_edit:false', ‘replicate:false'],
        '/conf'  => ['read:true', 'modify:false', 'create:false', 'delete:false', 'acl_read:true', 'acl_edit:false', 'replicate:false'],
        '/content'  => ['read:true', 'modify:false', 'create:false', 'delete:false', 'acl_read:true', 'acl_edit:false', 'replicate:false'],
        '/etc'  => ['read:true', 'modify:false', 'create:false', 'delete:false', 'acl_read:true', 'acl_edit:false', ‘replicate:false'],
        '/etc/packages'  => ['read:true', 'modify:true', 'create:true', 'delete:true', 'acl_read:true', 'acl_edit:true', ‘replicate:false'],
        '/home'  => ['read:true', 'modify:false', 'create:false', 'delete:false', 'acl_read:true', 'acl_edit:false', 'replicate:false'],
        '/oak:index'  => ['read:true', 'modify:false', 'create:false', 'delete:false', 'acl_read:true', 'acl_edit:false', ‘replicate:false'],
        '/system' => ['read:false', 'modify:false', 'create:false', 'delete:false', 'acl_read:false', 'acl_edit:false', ‘replicate:false'],
        '/tmp' => ['read:false', 'modify:false', 'create:false', 'delete:false', 'acl_read:false', 'acl_edit:false', ‘replicate:false'],
        '/var' => ['read:false', 'modify:false', 'create:false', 'delete:false', 'acl_read:false', 'acl_edit:false', 'replicate:false'],
      },
    },
    importer => {
      name => 'importer',
      path => '/home/users/i',
      permission => {
        '/' => ['read:true', 'modify:false', 'create:false', 'delete:false', 'acl_read:false', 'acl_edit:false', 'replicate:false'],
        '/apps' => ['read:false', 'modify:false', 'create:false', 'delete:false', 'acl_read:false', 'acl_edit:false', ‘replicate:false'],
        '/conf'  => ['read:false', 'modify:false', 'create:false', 'delete:false', 'acl_read:false', 'acl_edit:false', 'replicate:false'],  
        '/content'  => ['read:false', 'modify:false', 'create:false', 'delete:false', 'acl_read:false', 'acl_edit:false', 'replicate:false'],
        '/etc'  => ['read:true', 'modify:false', 'create:false', 'delete:false', 'acl_read:false', 'acl_edit:true', ‘replicate:false’],
        ‘/etc/replication'  => ['read:true', 'modify:true', 'create:true', 'delete:true', 'acl_read:true', 'acl_edit:false', ‘replicate:false’],
        '/home'  => ['read:false', 'modify:false', 'create:false', 'delete:false', 'acl_read:false', 'acl_edit:false', ‘replicate:false’],
        '/libs'  => ['read:true', 'modify:false', 'create:false', 'delete:false', 'acl_read:false', 'acl_edit:false', ‘replicate:false'],
        ‘/oak:index'  => ['read:false', 'modify:false', 'create:false', 'delete:false', 'acl_read:false', 'acl_edit:false', ‘replicate:false'],
        '/system' => ['read:false', 'modify:false', 'create:false', 'delete:false', 'acl_read:false', 'acl_edit:false', ‘replicate:false'],
        '/tmp' => ['read:false', 'modify:false', 'create:false', 'delete:false', 'acl_read:false', 'acl_edit:false', ‘replicate:false'],
        '/var' => ['read:false', 'modify:false', 'create:false', 'delete:false', 'acl_read:false', 'acl_edit:false', 'replicate:false'],
      },
    },
    orchestrator => {
      name => 'orchestrator',
      path => '/home/users/o',
      permission => {
        '/' => ['read:true', 'modify:false', 'create:false', 'delete:false', 'acl_read:false', 'acl_edit:false', 'replicate:false'],
        '/apps' => ['read:false', 'modify:false', 'create:false', 'delete:false', 'acl_read:false', 'acl_edit:false', ‘replicate:false'],
        '/conf'  => ['read:false', 'modify:false', 'create:false', 'delete:false', 'acl_read:false', 'acl_edit:false', 'replicate:false'],  
        '/content'  => ['read:false', 'modify:false', 'create:false', 'delete:false', 'acl_read:false', 'acl_edit:false', 'replicate:false'],
        '/etc'  => ['read:true', 'modify:false', 'create:false', 'delete:false', 'acl_read:false', 'acl_edit:true', ‘replicate:false’],
        ‘/etc/replication'  => ['read:true', 'modify:true', 'create:true', 'delete:true', 'acl_read:true', 'acl_edit:false', ‘replicate:false’],
        '/home'  => ['read:false', 'modify:false', 'create:false', 'delete:false', 'acl_read:false', 'acl_edit:false', ‘replicate:false’],
        '/libs'  => ['read:true', 'modify:false', 'create:false', 'delete:false', 'acl_read:false', 'acl_edit:false', ‘replicate:false'],
        ‘/oak:index'  => ['read:false', 'modify:false', 'create:false', 'delete:false', 'acl_read:false', 'acl_edit:false', ‘replicate:false'],
        '/system' => ['read:false', 'modify:false', 'create:false', 'delete:false', 'acl_read:false', 'acl_edit:false', ‘replicate:false'],
        '/tmp' => ['read:false', 'modify:false', 'create:false', 'delete:false', 'acl_read:false', 'acl_edit:false', ‘replicate:false'],
        '/var' => ['read:false', 'modify:false', 'create:false', 'delete:false', 'acl_read:false', 'acl_edit:false', 'replicate:false'],
      },
    },
    replicator => {
      name => 'replicator',
      path => '/home/users/r',
      permission => {
        '/apps' => ['read:true', 'modify:true', 'create:true', 'delete:true', 'acl_read:true', 'acl_edit:true', ‘replicate:true'],
        '/conf'  => ['read:true', 'modify:true', 'create:true', 'delete:true', 'acl_read:true', 'acl_edit:true', ‘replicate:true'],
        '/content'  => ['read:true', 'modify:true', 'create:true', 'delete:true', 'acl_read:true', 'acl_edit:true', ‘replicate:true'],
        '/etc'  => ['read:true', 'modify:true', 'create:true', 'delete:true', 'acl_read:true', 'acl_edit:true', ‘replicate:true'],
        '/home'  => ['read:true', 'modify:true', 'create:true', 'delete:true', 'acl_read:true', 'acl_edit:true', ‘replicate:true'],
        '/oak:index'  => ['read:true', 'modify:true', 'create:true', 'delete:true', 'acl_read:true', 'acl_edit:true', ‘replicate:true'],
    },
  )

  ensure_resources('aem_user', {
    "[${aem_id}] Create user - orchestrator" => {
      name     => $_aem_system_users[orchestrator][name],
      path     => $_aem_system_users[orchestrator][path],
      password => pick($_aem_system_users[orchestrator][password], 'orchestrator'),
      permission =>  $_aem_system_users[orchestrator][permission],

    },
    "[${aem_id}] Create user - replicator" => {
      name     => $_aem_system_users[replicator][name],
      path     => $_aem_system_users[replicator][path],
      password => pick($_aem_system_users[replicator][password], 'replicator'),
      permission     => $_aem_system_users[replicator][permission],
    },
    "[${aem_id}] Create user - deployer" => {
      name     => $_aem_system_users[deployer][name],
      path     => $_aem_system_users[deployer][path],
      password => pick($_aem_system_users[deployer][password], 'deployer'),
      permission     => $_aem_system_users[deployer][permission],
    },
    "[${aem_id}] Create user - exporter" => {
      name     => $_aem_system_users[exporter][name],
      path     => $_aem_system_users[exporter][path],
      password => pick($_aem_system_users[exporter][password], 'exporter'),
      permission     => $_aem_system_users[exporter][permission],
    },
    "[${aem_id}] Create user - importer" => {
      name     => $_aem_system_users[importer][name],
      path     => $_aem_system_users[importer][path],
      password => pick($_aem_system_users[importer][password], 'importer'),
      permission     => $_aem_system_users[importer][permission],
    }
  }, {
      aem_username => $aem_username,
      aem_password => $aem_password,
      aem_id       => $aem_id,
  })
}
