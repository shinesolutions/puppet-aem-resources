define aem_resources::publish_dispatcher_set_config(
  $dispatcher_conf_dir,
<<<<<<< HEAD
  $virtual_hosts_dir,
=======
  $apache_conf_dir,
>>>>>>> 475d5d2e8a3b3754673b09dd09ec4cbbe965a556
  $docroot_dir,
  $allowed_client,
  $publish_host,
  $publish_port,
  $publish_secure = '1',
  $ssl_cert = '/etc/httpd/aem.disp-cert',
) {

<<<<<<< HEAD
  $conf_dirs = [ $dispatcher_conf_dir, $virtual_hosts_dir ]
=======
  $conf_dirs = [ $dispatcher_conf_dir, $apache_conf_dir, ]
>>>>>>> 475d5d2e8a3b3754673b09dd09ec4cbbe965a556

  $unique_conf_dirs = unique($conf_dirs)

  file { $unique_conf_dirs:
    ensure => directory,
  }

  file { "${dispatcher_conf_dir}/dispatcher.farms.any":
    ensure  => file,
    content => epp('aem_resources/publish-dispatcher.farms.any.epp', {
      publish_host   => $publish_host,
      publish_port   => $publish_port,
      publish_secure => $publish_secure,
      docroot_dir    => $docroot_dir,
      allowed_client => $allowed_client,
    }),
    mode    => '0664',
    require =>  File[$dispatcher_conf_dir],
  }

<<<<<<< HEAD
  file { "${virtual_hosts_dir}/1-puppet-aem-resources.conf":
=======
  file { "${apache_conf_dir}/1-puppet-aem-resources.conf":
>>>>>>> 475d5d2e8a3b3754673b09dd09ec4cbbe965a556
    ensure  => file,
    content => epp('aem_resources/httpd.conf.epp', {
      docroot_dir => $docroot_dir,
      ssl_cert    => $ssl_cert,
    }),
    mode    => '0664',
<<<<<<< HEAD
    require => File[$virtual_hosts_dir],
=======
    require => File[$apache_conf_dir],
>>>>>>> 475d5d2e8a3b3754673b09dd09ec4cbbe965a556
  }

}
