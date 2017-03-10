class aem_resources::publish_set_osgi_config(
) {

  # Security - DoS prevention
  aem_node { 'Create Apache Sling GET Servlet config node':
    ensure => present,
    name   => 'org.apache.sling.servlets.get.DefaultGetServlet',
    path   => '/apps/system/config.publish',
    type   => 'sling:OsgiConfig',
  } ->
  aem_config_property { 'Limit depth of JSON rendering':
    ensure           => present,
    name             => 'json.maximumresults',
    type             => 'String',
    value            => '100',
    run_mode         => 'publish',
    config_node_name => 'org.apache.sling.servlets.get.DefaultGetServlet',
  } ->
  aem_config_property { 'Disable HTML renderer':
    ensure           => present,
    name             => 'enable.html',
    type             => 'Boolean',
    value            => false,
    run_mode         => 'publish',
    config_node_name => 'org.apache.sling.servlets.get.DefaultGetServlet',
  } ->
  aem_config_property { 'Disable plain text renderer':
    ensure           => present,
    name             => 'enable.txt',
    type             => 'Boolean',
    value            => false,
    run_mode         => 'publish',
    config_node_name => 'org.apache.sling.servlets.get.DefaultGetServlet',
  } ->
  aem_config_property { 'Disable XML renderer':
    ensure           => present,
    name             => 'enable.xml',
    type             => 'Boolean',
    value            => false,
    run_mode         => 'publish',
    config_node_name => 'org.apache.sling.servlets.get.DefaultGetServlet',
  }

}
