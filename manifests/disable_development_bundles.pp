define aem_resources::disable_development_bundles(
  $run_mode,
  $aem_username = undef,
  $aem_password = undef,
  $aem_id = 'aem',
) {

  # # Note: com.adobe.granite.crxde-support is commented out since it doesn't exist on AEM 6.5 but it's still listed on AEM 6.5 security guideline
  # aem_bundle { "[${aem_id}] Stop Adobe CRXDE Support bundle":
  #   ensure       => stopped,
  #   name         => 'com.adobe.granite.crxde-support',
  #   aem_username => $aem_username,
  #   aem_password => $aem_password,
  #   aem_id       => $aem_id,
  # }

  aem_bundle { "[${aem_id}] Stop Adobe Granite CRX Explorer bundle":
    ensure       => stopped,
    name         => 'com.adobe.granite.crx-explorer',
    aem_username => $aem_username,
    aem_password => $aem_password,
    aem_id       => $aem_id,
  }

  aem_bundle { "[${aem_id}] Stop Adobe Granite CRXDE Lite bundle":
    ensure       => stopped,
    name         => 'com.adobe.granite.crxde-lite',
    aem_username => $aem_username,
    aem_password => $aem_password,
    aem_id       => $aem_id,
  }

}
