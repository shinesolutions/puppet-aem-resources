define aem_resources::set_osgi_config(
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

    aem::osgi::config { "[${aem_id}]: Set Osgi Config ${pid}":
      ensure     => $ensure,
      group      => $aem_user_group,
      home       => $aem_home_dir,
      pid        => $pid,
      properties => $props,
      type       => 'file',
      user       => $aem_user
    }
  }
}
