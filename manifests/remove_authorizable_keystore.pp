define aem_resources::remove_authorizable_keystore(
  $aem_id            = 'aem',
  $aem_username      = undef,
  $aem_password      = undef,
  $authorizable_id   = undef,
  $intermediate_path = undef,
) {
  aem_authorizable_keystore { "[${aem_id}] Delete Keystore for user ${authorizable_id}":
    ensure            => absent,
    aem_id            => $aem_id,
    aem_username      => $aem_username,
    aem_password      => $aem_password,
    authorizable_id   => $authorizable_id,
    intermediate_path => $intermediate_path,
  }
}
