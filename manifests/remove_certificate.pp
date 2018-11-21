define aem_resources::remove_certificate(
  $aem_id          = 'aem',
  $aem_username    = undef,
  $aem_password    = undef,
  $file            = undef,
  $serial          = undef,
) {
  if  $serial {
    $params_remove_certificate = {
      aem_certificate => {
        serial => $serial
      }
    }
  } elsif $file {
    $params_remove_certificate = {
      aem_certificate => {
        file => $file
      }
    }
  }

  $default_params_remove_certificate = {
    ensure       => absent,
    aem_id       => $aem_id,
    aem_username => $aem_username,
    aem_password => $aem_password,
  }

  create_resources(
    aem_certificate,
    $params_remove_certificate,
    $default_params_remove_certificate
  )
}
