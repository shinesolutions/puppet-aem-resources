aem_outbox_replication_agent { 'Delete outbox replication agent':
  ensure   => absent,
  name     => 'some-outbox-replication-agent',
  run_mode => 'publish',
}
