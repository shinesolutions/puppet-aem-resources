aem_replication_agent { 'Create/update replication agent':
  ensure             => present,
  name               => 'some-replication-agent',
  run_mode           => 'author',
  title              => 'Some replication Agent Title',
  description        => 'Some replication agent description',
  dest_base_url      => 'http://somehost:8080',
  transport_user     => 'someuser',
  transport_password => 'somepass',
  log_level          => 'info',
  retry_delay        => 60000,
  force              => true,
}
