define aem_resources::publish_set_osgi_config(
  $aem_id = 'aem',
) {

  # Security - CSRF attacks prevention
  aem_node { "[${aem_id}] Create Apache Sling Referrer Filter config node":
    ensure => present,
    name   => 'org.apache.sling.security.impl.ReferrerFilter',
    path   => '/apps/system/config.publish',
    type   => 'sling:OsgiConfig',
    aem_id => $aem_id,
  } -> aem_config_property { "[${aem_id}] Do not allow empty referrer":
    ensure           => present,
    name             => 'allow.empty',
    type             => 'Boolean',
    value            => false,
    run_mode         => 'publish',
    config_node_name => 'org.apache.sling.security.impl.ReferrerFilter',
    aem_id           => $aem_id,
  }

  # Security - DoS prevention
  aem_node { "[${aem_id}] Create Apache Sling GET Servlet config node":
    ensure => present,
    name   => 'org.apache.sling.servlets.get.DefaultGetServlet',
    path   => '/apps/system/config.publish',
    type   => 'sling:OsgiConfig',
    aem_id => $aem_id,
  } -> aem_config_property { "[${aem_id}] Limit depth of JSON rendering":
    ensure           => present,
    name             => 'json.maximumresults',
    type             => 'String',
    value            => '100',
    run_mode         => 'publish',
    config_node_name => 'org.apache.sling.servlets.get.DefaultGetServlet',
    aem_id           => $aem_id,
  } -> aem_config_property { "[${aem_id}] Disable HTML renderer":
    ensure           => present,
    name             => 'enable.html',
    type             => 'Boolean',
    value            => false,
    run_mode         => 'publish',
    config_node_name => 'org.apache.sling.servlets.get.DefaultGetServlet',
    aem_id           => $aem_id,
  } -> aem_config_property { "[${aem_id}] Disable plain text renderer":
    ensure           => present,
    name             => 'enable.txt',
    type             => 'Boolean',
    value            => false,
    run_mode         => 'publish',
    config_node_name => 'org.apache.sling.servlets.get.DefaultGetServlet',
    aem_id           => $aem_id,
  } -> aem_config_property { "[${aem_id}] Disable XML renderer":
    ensure           => present,
    name             => 'enable.xml',
    type             => 'Boolean',
    value            => false,
    run_mode         => 'publish',
    config_node_name => 'org.apache.sling.servlets.get.DefaultGetServlet',
    aem_id           => $aem_id,
  }

}
