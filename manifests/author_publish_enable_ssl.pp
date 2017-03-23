class aem_resources::author_publish_enable_ssl(
  $run_mode,
  $port,
  $crx_quickstart_dir,
  $keystore_cert,
  $keystore_password,
  $keystore_key_alias,
  $keystore_private_key,
  $keystore_key_password,
  $truststore_cert,
  $truststore_password,
  $keystore_trustcacerts = false,
  $truststore_trustcacerts = false,
) {

  file { "${crx_quickstart_dir}/ssl/":
    ensure => directory,
  }

  java_ks { 'Set up keystore':
    ensure       => latest,
    certificate  => $keystore_cert,
    target       => "${crx_quickstart_dir}/ssl/aem.keystore",
    private_key  => $keystore_private_key,
    password     => $keystore_password,
    trustcacerts => $keystore_trustcacerts,
  }

  java_ks { 'Set up truststore':
    ensure       => latest,
    certificate  => $truststore_cert,
    target       => "${crx_quickstart_dir}/ssl/aem.truststore",
    password     => $truststore_password,
    trustcacerts => $truststore_trustcacerts,
  }

  aem_node { 'Ensure org.apache.felix.http OSGI config exists':
    ensure => present,
    name   => 'org.apache.felix.http',
    path   => "/apps/system/config.${run_mode}",
    type   => 'sling:OsgiConfig',
  }

  aem_config_property { 'Create org.osgi.service.http.port.secure property':
    ensure           => present,
    name             => 'org.osgi.service.http.port.secure',
    type             => 'Long',
    value            => $port,
    run_mode         => $run_mode,
    config_node_name => 'org.apache.felix.http',
  }

  aem_aem { 'Wait until org.osgi.service.http.port.secure property is set':
    ensure => login_page_is_ready,
  }

  aem_config_property { 'Create org.apache.felix.https.keystore property':
    ensure           => present,
    name             => 'org.apache.felix.https.keystore',
    type             => 'String',
    value            => "${crx_quickstart_dir}/ssl/aem.keystore",
    run_mode         => $run_mode,
    config_node_name => 'org.apache.felix.http',
  }

  aem_aem { 'Wait until org.apache.felix.https.keystore property is set':
    ensure => login_page_is_ready,
  }

  aem_config_property { 'Create org.apache.felix.https.keystore.password property':
    ensure           => present,
    name             => 'org.apache.felix.https.keystore.password',
    type             => 'String',
    value            => $keystore_password,
    run_mode         => $run_mode,
    config_node_name => 'org.apache.felix.http',
  }

  aem_aem { 'Wait until org.apache.felix.https.keystore.password property is set':
    ensure => login_page_is_ready,
  }

  aem_config_property { 'Create org.apache.felix.https.keystore.key property':
    ensure           => present,
    name             => 'org.apache.felix.https.keystore.key',
    type             => 'String',
    value            => $keystore_key_alias,
    run_mode         => $run_mode,
    config_node_name => 'org.apache.felix.http',
  }

  aem_aem { 'Wait until org.apache.felix.https.keystore.key property is set':
    ensure => login_page_is_ready,
  }

  aem_config_property { 'Create org.apache.felix.https.keystore.key.password property':
    ensure           => present,
    name             => 'org.apache.felix.https.keystore.key.password',
    type             => 'String',
    value            => $keystore_key_password,
    run_mode         => $run_mode,
    config_node_name => 'org.apache.felix.http',
  }

  aem_aem { 'Wait until org.apache.felix.https.keystore.key.password property is set':
    ensure => login_page_is_ready,
  }

  aem_config_property { 'Create org.apache.felix.https.truststore property':
    ensure           => present,
    name             => 'org.apache.felix.https.truststore',
    type             => 'String',
    value            => "${crx_quickstart_dir}/ssl/aem.truststore",
    run_mode         => $run_mode,
    config_node_name => 'org.apache.felix.http',
  }

  aem_aem { 'Wait until org.apache.felix.https.truststore property is set':
    ensure => login_page_is_ready,
  }

  aem_config_property { 'Create org.apache.felix.https.truststore.password property':
    ensure           => present,
    name             => 'org.apache.felix.https.truststore.password',
    type             => 'String',
    value            => $truststore_password,
    run_mode         => $run_mode,
    config_node_name => 'org.apache.felix.http',
  }

  aem_aem { 'Wait until org.apache.felix.https.truststore.password property is set':
    ensure => login_page_is_ready,
  }

  aem_config_property { 'Create org.apache.felix.https.nio property':
    ensure           => present,
    name             => 'org.apache.felix.https.nio',
    type             => 'Boolean',
    value            => true,
    run_mode         => $run_mode,
    config_node_name => 'org.apache.felix.http',
  }

  aem_aem { 'Wait until org.apache.felix.https.nio property':
    ensure => login_page_is_ready,
  }

  aem_config_property { 'Create org.apache.felix.https.enable property':
    ensure           => present,
    name             => 'org.apache.felix.https.enable',
    type             => 'Boolean',
    value            => true,
    run_mode         => $run_mode,
    config_node_name => 'org.apache.felix.http',
  }

  aem_aem { 'Wait until org.apache.felix.https.enable property is set':
    ensure => login_page_is_ready,
  }

}
