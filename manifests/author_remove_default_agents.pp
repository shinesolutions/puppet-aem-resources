define aem_resources::author_remove_default_agents(
  $aem_username = undef,
  $aem_password = undef,
  $aem_id = 'aem',
) {

  aem_replication_agent { "[${aem_id}] Delete author replication agent - publish":
    ensure       => absent,
    name         => 'publish',
    run_mode     => 'author',
    aem_username => $aem_username,
    aem_password => $aem_password,
    aem_id       => $aem_id,
  }

  aem_flush_agent { "[${aem_id}] Delete author flush agent - flush":
    ensure       => absent,
    name         => 'flush',
    run_mode     => 'author',
    aem_username => $aem_username,
    aem_password => $aem_password,
    aem_id       => $aem_id,
  }

  aem_replication_agent { "[${aem_id}] Delete author replication agent - publish_reverse":
    ensure       => absent,
    name         => 'publish_reverse',
    run_mode     => 'author',
    aem_username => $aem_username,
    aem_password => $aem_password,
    aem_id       => $aem_id,
  }

  aem_replication_agent { "[${aem_id}] Delete author replication agent - static":
    ensure       => absent,
    name         => 'static',
    run_mode     => 'author',
    aem_username => $aem_username,
    aem_password => $aem_password,
    aem_id       => $aem_id,
  }

  aem_replication_agent { "[${aem_id}] Delete author replication agent - test_and_target":
    ensure       => absent,
    name         => 'test_and_target',
    run_mode     => 'author',
    aem_username => $aem_username,
    aem_password => $aem_password,
    aem_id       => $aem_id,
  }

  aem_replication_agent { "[${aem_id}] Delete author replication agent - dynamic_media_replication":
    ensure       => absent,
    name         => 'dynamic_media_replication',
    run_mode     => 'author',
    aem_username => $aem_username,
    aem_password => $aem_password,
    aem_id       => $aem_id,
  }

  aem_replication_agent { "[${aem_id}] Delete author replication agent - s7delivery":
    ensure       => absent,
    name         => 's7delivery',
    run_mode     => 'author',
    aem_username => $aem_username,
    aem_password => $aem_password,
    aem_id       => $aem_id,
  }

  aem_replication_agent { "[${aem_id}] Delete author replication agent - offloading_outbox":
    ensure       => absent,
    name         => 'offloading_outbox',
    run_mode     => 'author',
    aem_username => $aem_username,
    aem_password => $aem_password,
    aem_id       => $aem_id,
  }

  # Remove screens default URI user - as it triggers the warn message of the Replication and Transport Users healthcheck
  aem_flush_agent { "[${aem_id}] Delete publish flush agent - resource-only-flush":
    ensure       => absent,
    name         => 'screens',
    run_mode     => 'author',
    aem_username => $aem_username,
    aem_password => $aem_password,
    aem_id       => $aem_id,
  }

}
