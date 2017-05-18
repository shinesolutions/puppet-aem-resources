aem_user { 'Update replication-service user permission':
  ensure     => has_permission,
  name       => 'replication-service',
  path       => '/home/users/system/',
  permission => {
    '/etc/replication/agents.author' => ['replicate:false'],
    '/etc/replication/agents.publish' => ['replicate:false']
  }
}
