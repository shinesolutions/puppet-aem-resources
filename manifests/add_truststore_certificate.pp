define aem_resources::add_truststore_certificate(
  $aem_id          = 'aem',
  $force           = true,
  $aem_username    = undef,
  $aem_password    = undef,
  $file            = undef,
) {

  $params_add_certificate = {
    aem_certificate => {
      file => $file
    }
  }

  $default_params_add_certificate = {
    ensure       => present,
    aem_id       => $aem_id,
    aem_username => $aem_username,
    aem_password => $aem_password,
    force        => $force,
  }

  create_resources(
    aem_certificate,
    $params_add_certificate,
    $default_params_add_certificate
  )
}
