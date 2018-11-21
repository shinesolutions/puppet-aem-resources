  define aem_resources::create_truststore(
  $aem_id              = 'aem',
  $aem_username        = undef,
  $aem_password        = undef,
  $file                = undef,
  $truststore_password = undef,
) {

  if $file {
    aem_truststore { "[${aem_id}] Import Truststore backup from file":
      ensure       => present,
      aem_id       => $aem_id,
      aem_username => $aem_username,
      aem_password => $aem_password,
      password     => $truststore_password,
      file         => $file
    }
  } else {
    aem_truststore { "[${aem_id}] Create new Truststore":
      ensure       => present,
      aem_id       => $aem_id,
      aem_username => $aem_username,
      aem_password => $aem_password,
      password     => $truststore_password,
    }
  }
}
