define aem_resources::enable_crxde(
  $run_mode,
  $aem_username = undef,
  $aem_password = undef,
  $aem_id = 'aem',
) {

  aem_bundle { "[${aem_id}] Start davex bundle":
    ensure       => started,
    name         => 'org.apache.sling.jcr.davex',
    aem_username => $aem_username,
    aem_password => $aem_password,
    aem_id       => $aem_id,
  } -> aem_aem { "[${aem_id}]: Wait until login page is ready after starting davex bundle":
    ensure       => login_page_is_ready,
    aem_id       => $aem_id,
    aem_username => $aem_username,
    aem_password => $aem_password,
  } -> aem_aem { "${aem_id}: Wait until aem health check is ok after starting davex bundle":
    ensure       => aem_health_check_is_ok,
    tags         => 'deep',
    aem_id       => $aem_id,
    aem_username => $aem_username,
    aem_password => $aem_password,
  } -> aem_node { "[${aem_id}] Create Apache Sling DavEx Servlet config node":
    ensure       => present,
    name         => 'org.apache.sling.jcr.davex.impl.servlets.SlingDavExServlet',
    path         => "/apps/system/config.${$run_mode}",
    type         => 'sling:OsgiConfig',
    aem_username => $aem_username,
    aem_password => $aem_password,
    aem_id       => $aem_id,
  } -> aem_config_property { "[${aem_id}] Enable CRXDE Lite alias":
    ensure           => present,
    name             => 'alias',
    type             => 'String',
    value            => '/crx/server',
    run_mode         => $run_mode,
    config_node_name => 'org.apache.sling.jcr.davex.impl.servlets.SlingDavExServlet',
    aem_username     => $aem_username,
    aem_password     => $aem_password,
    aem_id           => $aem_id,
  } -> aem_config_property { "[${aem_id}] Enable CRXDE Lite create-absolute-uri":
    ensure           => present,
    name             => 'dav.create-absolute-uri',
    type             => 'Boolean',
    value            => true,
    run_mode         => $run_mode,
    config_node_name => 'org.apache.sling.jcr.davex.impl.servlets.SlingDavExServlet',
    aem_username     => $aem_username,
    aem_password     => $aem_password,
    aem_id           => $aem_id,
  }

}
