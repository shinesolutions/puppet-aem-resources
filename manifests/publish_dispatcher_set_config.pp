class aem_resources::publish_dispatcher_set_config(
  $conf_dir,
  $docroot_dir,
  $publish_host,
  $publish_port,
) {

  file { "${conf_dir}":
    ensure => directory,
  } ->
  file { "${conf_dir}/dispatcher.farms.any":
    ensure  => file,
    content => epp('aem_resources/publish-dispatcher.farms.any.epp', { publish_host => "${publish_host}", publish_port => "${publish_port}", docroot_dir => "${docroot_dir}" }),
    mode    => '0664',
  }

}
