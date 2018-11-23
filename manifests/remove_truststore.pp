define aem_resources::remove_truststore(
  $aem_id       = 'aem',
  $aem_username = undef,
  $aem_password = undef,
) {
  aem_truststore { "[${aem_id}] Remove truststore":
    ensure       => absent,
    aem_id       => $aem_id,
    aem_username => $aem_username,
    aem_password => $aem_password
  }
}
