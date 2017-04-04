class { 'aem_resources::change_system_users_password':
  orchestrator_new_password => 'orchestrator',
  replicator_new_password   => 'replicator',
  deployer_new_password     => 'deployer',
  exporter_new_password     => 'exporter',
  importer_new_password     => 'importer',
}
