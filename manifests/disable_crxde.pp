define aem_resources::disable_crxde(
  $run_mode,
  $aem_username = undef,
  $aem_password = undef,
  $aem_id = 'aem',
) {

  aem_bundle { "[${aem_id}] Stop davex bundle":
    ensure       => stopped,
    name         => 'org.apache.sling.jcr.davex',
    aem_username => $aem_username,
    aem_password => $aem_password,
    aem_id       => $aem_id,
  } -> aem_config_property { "[${aem_id}] Disable CRXDE Lite alias":
    ensure           => absent,
    name             => 'alias',
    type             => 'String',
    value            => '/crx/server',
    run_mode         => $run_mode,
    config_node_name => 'org.apache.sling.jcr.davex.impl.servlets.SlingDavExServlet',
    aem_username     => $aem_username,
    aem_password     => $aem_password,
    aem_id           => $aem_id,
  } -> aem_config_property { "[${aem_id}] Disable CRXDE Lite create-absolute-uri":
    ensure           => absent,
    name             => 'dav.create-absolute-uri',
    type             => 'Boolean',
    value            => false,
    run_mode         => $run_mode,
    config_node_name => 'org.apache.sling.jcr.davex.impl.servlets.SlingDavExServlet',
    aem_username     => $aem_username,
    aem_password     => $aem_password,
    aem_id           => $aem_id,
  }
}
