define aem_resources::publish_remove_default_agents(
  $aem_username = undef,
  $aem_password = undef,
  $aem_id = 'aem',
) {

  aem_flush_agent { "[${aem_id}] Delete publish flush agent - flush":
    ensure       => absent,
    name         => 'flush',
    run_mode     => 'publish',
    aem_username => $aem_username,
    aem_password => $aem_password,
    aem_id       => $aem_id,
  }

  aem_replication_agent { "[${aem_id}] Delete publish replication agent - outbox":
    ensure       => absent,
    name         => 'outbox',
    run_mode     => 'publish',
    aem_username => $aem_username,
    aem_password => $aem_password,
    aem_id       => $aem_id,
  }

  aem_flush_agent { "[${aem_id}] Delete publish flush agent - resource-only-flush":
    ensure       => absent,
    name         => 'resource-only-flush',
    run_mode     => 'publish',
    aem_username => $aem_username,
    aem_password => $aem_password,
    aem_id       => $aem_id,
  }

  # Remove screens default URI user - as it triggers the warn message of the Replication and Transport Users healthcheck
  # The screens healthcheck is only defined in the author healthchecks
  aem_flush_agent { "[${aem_id}] Delete author screens agent":
    ensure       => absent,
    name         => 'screens',
    run_mode     => 'author',
    aem_username => $aem_username,
    aem_password => $aem_password,
    aem_id       => $aem_id,
  }
}
