define aem_resources::disable_crxde(
  $run_mode,
  $aem_username = undef,
  $aem_password = undef,
  $aem_id = 'aem',
) {

  aem_bundle { "[${aem_id}] Stop davex bundle":
    ensure       => stopped,
    name         => 'org.apache.sling.jcr.davex',
    aem_username => $aem_username,
    aem_password => $aem_password,
    aem_id       => $aem_id,
  }
}
