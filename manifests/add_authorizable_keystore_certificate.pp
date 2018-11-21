define aem_resources::add_authorizable_keystore_certificate(
  $aem_id                      = 'aem',
  $aem_username                = undef,
  $aem_password                = undef,
  $authorizable_id             = undef,
  $certificate_chain_file_path = undef,
  $intermediate_path           = undef,
  $private_key_file_path       = undef,
  $private_key_alias           = undef,
) {
  $params_add_keystore_certificate = {
    aem_certificate_chain => {
      certificate_chain_file_path => $certificate_chain_file_path
    }
  }

  $default_params_add_keystore_certificate = {
    ensure                => present,
    aem_id                => $aem_id,
    aem_username          => $aem_username,
    aem_password          => $aem_password,
    authorizable_id       => $authorizable_id,
    intermediate_path     => $intermediate_path,
    private_key_file_path => $private_key_file_path,
    private_key_alias     => $private_key_alias,
  }

  create_resources(
    aem_certificate_chain,
    $params_add_keystore_certificate,
    $default_params_add_keystore_certificate
  )
}
