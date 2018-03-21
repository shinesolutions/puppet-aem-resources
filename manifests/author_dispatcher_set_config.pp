define aem_resources::author_dispatcher_set_config(
  $dispatcher_conf_dir,
  $apache_conf_dir,
  $docroot_dir,
  $author_host,
  $author_port,
  $author_secure = '1',
  $ssl_cert = '/etc/httpd/aem.disp-cert',
) {

  $conf_dirs = [ $dispatcher_conf_dir, $apache_conf_dir, ]

  $unique_conf_dirs = unique($conf_dirs)

  file { $unique_conf_dirs:
    ensure => directory,
  }

  file { "${dispatcher_conf_dir}/dispatcher.farms.any":
    ensure  => file,
    content => epp('aem_resources/author-dispatcher.farms.any.epp', {
      author_host   => $author_host,
      author_port   => $author_port,
      author_secure => $author_secure,
      docroot_dir   => $docroot_dir,
    }),
    mode    => '0664',
    require =>  File[$dispatcher_conf_dir],
  }

  file { "${dispatcher_conf_dir}/1-puppet-aem-resources.conf":
    ensure  => file,
    content => epp('aem_resources/httpd.conf.epp', {
      docroot_dir => $docroot_dir,
      ssl_cert    => $ssl_cert,
    }),
    mode    => '0664',
    require => File[$apache_conf_dir],
  }

}
