class aem_resources::author_dispatcher_set_config(
  $conf_dir,
  $docroot_dir,
  $author_host,
  $author_port,
) {

  file { "${conf_dir}":
    ensure => directory,
  } ->
  file { "${conf_dir}/dispatcher.farms.any":
    ensure  => file,
    content => epp('aem_resources/author-dispatcher.farms.any.epp', { author_host => "${author_host}", author_port => "${author_port}", docroot_dir => "${docroot_dir}" }),
    mode    => '0664',
  }

}
