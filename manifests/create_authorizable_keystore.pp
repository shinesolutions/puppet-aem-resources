define aem_resources::create_authorizable_keystore(
  $aem_id                         = 'aem',
  $aem_username                   = undef,
  $aem_password                   = undef,
  $authorizable_id                = undef,
  $intermediate_path              = undef,
  $authorizable_keystore_password = undef,
) {
  aem_authorizable_keystore { "[${aem_id}] Create new Keystore for user ${authorizable_id}":
    ensure            => present,
    aem_id            => $aem_id,
    aem_username      => $aem_username,
    aem_password      => $aem_password,
    authorizable_id   => $authorizable_id,
    intermediate_path => $intermediate_path,
    password          => $authorizable_keystore_password,
  }
}
