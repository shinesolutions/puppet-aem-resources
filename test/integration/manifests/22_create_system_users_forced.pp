aem_resources::create_system_users { 'Create system users with predefined password':
  orchestrator_password => 'neworchestratorpassword',
  replicator_password   => 'newreplicatorpassword',
  deployer_password     => 'newdeployerpassword',
  exporter_password     => 'newexporterpassword',
  importer_password     => 'newimporterpassword',
}
