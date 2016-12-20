aem_flush_agent { 'Create/update flush agent':
  ensure        => present,
  name          => 'some-flush-agent',
  run_mode      => 'author',
  title         => 'Some Flush Agent Title',
  description   => 'Some flush agent description',
  dest_base_url => 'http://somehost:8080',
  force         => true,
}
