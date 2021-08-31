define aem_resources::enable_development_bundles(
  $run_mode,
  $aem_username = undef,
  $aem_password = undef,
  $aem_id = 'aem',
) {

  # # Note: com.adobe.granite.crxde-support is commented out since it doesn't exist on AEM 6.5 but it's still listed on AEM 6.5 security guideline
  # aem_bundle { "[${aem_id}] Start Adobe CRXDE Support bundle":
  #   ensure       => started,
  #   name         => 'com.adobe.granite.crxde-support',
  #   aem_username => $aem_username,
  #   aem_password => $aem_password,
  #   aem_id       => $aem_id,
  # } ->
  aem_bundle { "[${aem_id}] Start Adobe Granite CRX Explorer bundle":
    ensure       => started,
    name         => 'com.adobe.granite.crx-explorer',
    aem_username => $aem_username,
    aem_password => $aem_password,
    aem_id       => $aem_id,
  } -> aem_bundle { "[${aem_id}] Start Adobe Granite CRXDE Lite bundle":
    ensure       => started,
    name         => 'com.adobe.granite.crxde-lite',
    aem_username => $aem_username,
    aem_password => $aem_password,
    aem_id       => $aem_id,
  } -> aem_aem { "[${aem_id}]: Wait until login page is ready after starting development bundles":
    ensure       => login_page_is_ready,
    aem_id       => $aem_id,
    aem_username => $aem_username,
    aem_password => $aem_password,
  } -> aem_aem { "${aem_id}: Wait until aem health check is ok after starting development bundles":
    ensure       => aem_health_check_is_ok,
    tags         => 'deep',
    aem_id       => $aem_id,
    aem_username => $aem_username,
    aem_password => $aem_password,
  }

}
