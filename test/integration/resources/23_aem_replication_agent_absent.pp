aem_replication_agent { 'Delete replication agent':
  ensure   => absent,
  name     => 'some-replication-agent',
  run_mode => 'author',
}
