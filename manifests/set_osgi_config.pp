define aem_resources::set_osgi_config (
  $aem_home_dir   = undef,
  $aem_id         = 'aem',
  $aem_user       = 'aem',
  $aem_user_group = 'aem',
  $ensure         = 'present',
  $osgi_configs   = {},
) {
  $osgi_configs.each | $key, $values | {
    if $values['properties'] {
      $props = $values['properties']
      $pid = $values['pid']
    } else {
      $props = $values
      $pid = $key
    }

    # Internal port of aem::osgi::config (type file): bstopp/aem is unmaintained and incompatible with OpenVox 9
    aem_resources::osgi_config_file { "[${aem_id}]: Set Osgi Config ${pid}":
      ensure     => $ensure,
      group      => $aem_user_group,
      home       => $aem_home_dir,
      pid        => $pid,
      properties => $props,
      user       => $aem_user,
    }
  }
}
