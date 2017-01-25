class aem_resources::author_remove_default_agents(
) {

  aem_replication_agent { 'Delete author replication agent - publish':
    ensure   => absent,
    name     => 'publish',
    run_mode => 'author',
  }

  aem_flush_agent { 'Delete author flush agent - flush':
    ensure   => absent,
    name     => 'flush',
    run_mode => 'author',
  }

  aem_replication_agent { 'Delete author replication agent - publish_reverse':
    ensure   => absent,
    name     => 'publish_reverse',
    run_mode => 'author',
  }

  aem_replication_agent { 'Delete author replication agent - static':
    ensure   => absent,
    name     => 'static',
    run_mode => 'author',
  }

  aem_replication_agent { 'Delete author replication agent - test_and_target':
    ensure   => absent,
    name     => 'test_and_target',
    run_mode => 'author',
  }

  aem_replication_agent { 'Delete author replication agent - dynamic_media_replication':
    ensure   => absent,
    name     => 'dynamic_media_replication',
    run_mode => 'author',
  }

  aem_replication_agent { 'Delete author replication agent - s7delivery':
    ensure   => absent,
    name     => 's7delivery',
    run_mode => 'author',
  }

  aem_replication_agent { 'Delete author replication agent - offloading_outbox':
    ensure   => absent,
    name     => 'offloading_outbox',
    run_mode => 'author',
  }
}
