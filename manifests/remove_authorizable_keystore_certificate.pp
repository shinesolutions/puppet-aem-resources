define aem_resources::remove_authorizable_keystore_certificate(
  $aem_id            = 'aem',
  $aem_username      = undef,
  $aem_password      = undef,
  $authorizable_id   = undef,
  $intermediate_path = undef,
  $private_key_alias = undef,
) {
  aem_certificate_chain { "[${aem_id}] Remove certificate chain from authorizable keystore for user ${authorizable_id}":
    ensure            => absent,
    aem_id            => $aem_id,
    aem_username      => $aem_username,
    aem_password      => $aem_password,
    authorizable_id   => $authorizable_id,
    intermediate_path => $intermediate_path,
    private_key_alias => $private_key_alias,
  }
}
