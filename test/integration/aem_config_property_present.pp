aem_config_property { 'Create https.enable property':
  ensure    => present,
  name      => 'org.apache.felix.https.enable',
  type      => 'Boolean',
  value     => true,
  run_mode  => 'author',
  node_name => 'org.apache.felix.http',
}
