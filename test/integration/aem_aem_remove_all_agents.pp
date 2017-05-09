aem_aem { 'Remove all agents':
  ensure   => all_agents_removed,
  run_mode => 'author',
}
