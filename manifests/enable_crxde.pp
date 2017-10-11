define aem_resources::enable_crxde(
  $run_mode,
  $aem_id = 'aem',
) {

  aem_bundle { 'Start davex bundle':
    ensure => started,
    name   => 'org.apache.sling.jcr.davex',
    aem_id => $aem_id,
  }

  aem_node { 'Create Apache Sling DavEx Servlet config node':
    ensure => present,
    name   => 'org.apache.sling.jcr.davex.impl.servlets.SlingDavExServlet',
    path   => "/apps/system/config.${$run_mode}",
    type   => 'sling:OsgiConfig',
    aem_id => $aem_id,
  } -> aem_config_property { 'Enable CRXDE Lite alias':
    ensure           => present,
    name             => 'alias',
    type             => 'String',
    value            => '/crx/server',
    run_mode         => $run_mode,
    config_node_name => 'org.apache.sling.jcr.davex.impl.servlets.SlingDavExServlet',
    aem_id           => $aem_id,
  } -> aem_config_property { 'Enable CRXDE Lite create-absolute-uri':
    ensure           => present,
    name             => 'dav.create-absolute-uri',
    type             => 'Boolean',
    value            => true,
    run_mode         => $run_mode,
    config_node_name => 'org.apache.sling.jcr.davex.impl.servlets.SlingDavExServlet',
    aem_id           => $aem_id,
  }

}
