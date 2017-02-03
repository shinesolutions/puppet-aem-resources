class aem_resources::publish_dispatcher_set_config(
  $dispatcher_conf_dir,
  $httpd_conf_dir,
  $docroot_dir,
  $publish_host,
  $publish_port,
) {

  file { "${dispatcher_conf_dir}":
    ensure => directory,
  } ->
  file { "${dispatcher_conf_dir}/dispatcher.farms.any":
    ensure  => file,
    content => epp('aem_resources/publish-dispatcher.farms.any.epp', {
      publish_host => "${publish_host}",
      publish_port => "${publish_port}",
      docroot_dir  => "${docroot_dir}"
    }),
    mode    => '0664',
  }

  file { "${httpd_conf_dir}":
    ensure => directory,
  } ->
  file { "${httpd_conf_dir}/1-puppet-aem-resources.conf":
    ensure  => file,
    content => epp('aem_resources/httpd.conf.epp', { docroot_dir => "${docroot_dir}" }),
    mode    => '0664',
  }

}
