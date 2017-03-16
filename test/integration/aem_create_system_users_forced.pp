class { 'aem_resources::create_system_users':
  orchestrator_password => 'neworchestratorpassword',
  replicator_password   => 'newreplicatorpassword',
  deployer_password     => 'newdeployerpassword',
  exporter_password     => 'newexporterpassword',
  importer_password     => 'newimporterpassword',
}
