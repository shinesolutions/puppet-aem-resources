class aem_resources::publish_remove_default_agents(
) {

  aem_flush_agent { 'Delete flush agent - flush':
    ensure   => absent,
    name     => 'flush',
    run_mode => 'publish',
  }

  aem_replication_agent { 'Delete replication agent - outbox':
    ensure   => absent,
    name     => 'outbox',
    run_mode => 'publish',
  }

  aem_flush_agent { 'Delete flush agent - resource-only-flush':
    ensure   => absent,
    name     => 'resource-only-flush',
    run_mode => 'publish',
  }
}
