aem_flush_agent { 'Delete flush agent':
  ensure   => absent,
  name     => 'some-flush-agent',
  run_mode => 'author',
}
