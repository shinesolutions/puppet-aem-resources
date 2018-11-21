define aem_resources::disable_saml(
  $aem_id       = 'aem',
  $aem_username = undef,
  $aem_password = undef,
) {
  aem_saml { "[${aem_id}] Disable SAML authentication":
    ensure       => absent,
    aem_username => $aem_username,
    aem_password => $aem_password,
    aem_id       => $aem_id,
  }
}
