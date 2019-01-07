  define aem_resources::archive_truststore(
  $aem_id              = 'aem',
  $aem_username        = undef,
  $aem_password        = undef,
  $file                = undef,
  $path                = undef,
) {

  if $file {
    aem_truststore { "[${aem_id}] Download Global Truststore to defined file path":
      ensure       => archived,
      aem_id       => $aem_id,
      aem_username => $aem_username,
      aem_password => $aem_password,
      file         => $file
    }
  } elsif $path {
    aem_truststore { "[${aem_id}] Download Global Truststore to defined path":
      ensure       => present,
      aem_id       => $aem_id,
      aem_username => $aem_username,
      aem_password => $aem_password,
      path         => $path,
    }
  }
}
