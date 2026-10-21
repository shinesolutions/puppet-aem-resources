aem_node { 'Create Apache Sling Referrer Filter config node':
  ensure => present,
  name   => 'org.apache.sling.security.impl.ReferrerFilter',
  path   => '/apps/system/config',
  type   => 'sling:OsgiConfig',
}

aem_config_property { 'Do not allow empty referrer':
  ensure           => present,
  name             => 'allow.empty',
  type             => 'Boolean',
  value            => false,
  run_mode         => 'publish',
  config_node_name => 'org.apache.sling.security.impl.ReferrerFilter',
}
