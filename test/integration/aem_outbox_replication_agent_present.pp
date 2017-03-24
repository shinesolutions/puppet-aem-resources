aem_outbox_replication_agent { 'Create/update outbox replication agent':
  ensure        => present,
  name          => 'some-outbox-replication-agent',
  run_mode      => 'publish',
  title         => 'Some Outbox Replication Agent Title',
  description   => 'Some outbox replication agent description',
  dest_base_url => 'http://somehost:8080',
  user_id       => 'someuser',
  log_level     => 'info',
  force         => true,
}
