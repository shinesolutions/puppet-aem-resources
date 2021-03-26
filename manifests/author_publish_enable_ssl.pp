define aem_resources::author_publish_enable_ssl(
  $port,
  $keystore,
  $keystore_password,
  $truststore,
  $truststore_password,
  $run_mode           = undef,
  $aem_username       = undef,
  $aem_password       = undef,
  $force              = false,
  $keystore_key_alias = undef,
  $aem_id             = 'aem',
  $https_hostname     = 'localhost',
  $ssl_method         = 'jetty',
) {
  case $ssl_method {
    /granite/: {
      aem_ssl { "[${aem_id}]  ] SSL by default for AEM":
        ensure                => present,
        aem_username          => $aem_username,
        aem_password          => $aem_password,
        force                 => $force,
        https_hostname        => $https_hostname,
        https_port            => $port,
        keystore_password     => $keystore_password,
        truststore_password   => $truststore_password,
        privatekey_file_path  => $keystore,
        certificate_file_path => $truststore,
        aem_id                => $aem_id,
      }
    }
    /jetty/: {
      aem_node { "[${aem_id}] Ensure org.apache.felix.http OSGI config exists":
        ensure       => present,
        name         => 'org.apache.felix.http',
        path         => '/apps/system/config',
        type         => 'sling:OsgiConfig',
        aem_username => $aem_username,
        aem_password => $aem_password,
        aem_id       => $aem_id,
      } -> exec { "[${aem_id}] Wait org.apache.felix.http OSGI config":
        command => 'sleep 5',
        path    => ['/usr/bin', '/usr/sbin', '/bin'],
      } -> aem_aem { "[${aem_id}] Wait until aem health check is ok org.apache.felix.http OSGI config":
        ensure       => aem_health_check_is_ok,
        tags         => 'deep',
        aem_username => $aem_username,
        aem_password => $aem_password,
        aem_id       => $aem_id,
      } -> aem_aem { "[${aem_id}] Wait until org.apache.felix.http OSGI config is set":
        ensure       => login_page_is_ready,
        aem_username => $aem_username,
        aem_password => $aem_password,
        aem_id       => $aem_id,
      } -> aem_config_property { "[${aem_id}] Create org.osgi.service.http.port.secure property":
        ensure           => present,
        name             => 'org.osgi.service.http.port.secure',
        type             => 'Long',
        value            => $port,
        run_mode         => $run_mode,
        config_node_name => 'org.apache.felix.http',
        aem_username     => $aem_username,
        aem_password     => $aem_password,
        aem_id           => $aem_id,
      } -> exec { "[${aem_id}] Wait org.osgi.service.http.port.secure property":
        command => 'sleep 5',
        path    => ['/usr/bin', '/usr/sbin', '/bin'],
      } -> aem_aem { "[${aem_id}] Wait until aem health check is ok org.osgi.service.http.port.secure":
        ensure       => aem_health_check_is_ok,
        tags         => 'deep',
        aem_username => $aem_username,
        aem_password => $aem_password,
        aem_id       => $aem_id,
      } -> aem_aem { "[${aem_id}] Wait until org.osgi.service.http.port.secure property is set":
        ensure       => login_page_is_ready,
        aem_username => $aem_username,
        aem_password => $aem_password,
        aem_id       => $aem_id,
      } -> aem_config_property { "[${aem_id}] Create org.apache.felix.https.keystore property":
        ensure           => present,
        name             => 'org.apache.felix.https.keystore',
        type             => 'String',
        value            => $keystore,
        run_mode         => $run_mode,
        config_node_name => 'org.apache.felix.http',
        aem_username     => $aem_username,
        aem_password     => $aem_password,
        aem_id           => $aem_id,
      } -> exec { "[${aem_id}] Wait org.apache.felix.https.keystore property":
        command => 'sleep 5',
        path    => ['/usr/bin', '/usr/sbin', '/bin'],
      } -> aem_aem { "[${aem_id}] Wait until aem health check is ok org.apache.felix.https.keystore property":
        ensure       => aem_health_check_is_ok,
        tags         => 'deep',
        aem_username => $aem_username,
        aem_password => $aem_password,
        aem_id       => $aem_id,
      } -> aem_aem { "[${aem_id}] Wait until org.apache.felix.https.keystore property is set":
        ensure       => login_page_is_ready,
        aem_username => $aem_username,
        aem_password => $aem_password,
        aem_id       => $aem_id,
      } -> aem_config_property { "[${aem_id}] Create org.apache.felix.https.keystore.password property":
        ensure           => present,
        name             => 'org.apache.felix.https.keystore.password',
        type             => 'String',
        value            => $keystore_password,
        run_mode         => $run_mode,
        config_node_name => 'org.apache.felix.http',
        aem_username     => $aem_username,
        aem_password     => $aem_password,
        aem_id           => $aem_id,
      } -> exec { "[${aem_id}] Wait org.apache.felix.https.keystore.password property":
        command => 'sleep 5',
        path    => ['/usr/bin', '/usr/sbin', '/bin'],
      } -> aem_aem { "[${aem_id}] Wait until aem health check is ok org.apache.felix.https.keystore.password property":
        ensure       => aem_health_check_is_ok,
        tags         => 'deep',
        aem_username => $aem_username,
        aem_password => $aem_password,
        aem_id       => $aem_id,
      } -> aem_aem { "[${aem_id}] Wait until org.apache.felix.https.keystore.password property is set":
        ensure       => login_page_is_ready,
        aem_username => $aem_username,
        aem_password => $aem_password,
        aem_id       => $aem_id,
      } -> aem_config_property { "[${aem_id}] Create org.apache.felix.https.keystore.key property":
        ensure           => present,
        name             => 'org.apache.felix.https.keystore.key',
        type             => 'String',
        value            => $keystore_key_alias,
        run_mode         => $run_mode,
        config_node_name => 'org.apache.felix.http',
        aem_username     => $aem_username,
        aem_password     => $aem_password,
        aem_id           => $aem_id,
      } -> exec { "[${aem_id}] Wait org.apache.felix.https.keystore.key property":
        command => 'sleep 5',
        path    => ['/usr/bin', '/usr/sbin', '/bin'],
      } -> aem_aem { "[${aem_id}] Wait until aem health check is ok org.apache.felix.https.keystore.key property":
        ensure       => aem_health_check_is_ok,
        tags         => 'deep',
        aem_username => $aem_username,
        aem_password => $aem_password,
        aem_id       => $aem_id,
      } -> aem_aem { "[${aem_id}] Wait until org.apache.felix.https.keystore.key property is set":
        ensure       => login_page_is_ready,
        aem_username => $aem_username,
        aem_password => $aem_password,
        aem_id       => $aem_id,
      } -> aem_config_property { "[${aem_id}] Create org.apache.felix.https.keystore.key.password property":
        ensure           => present,
        name             => 'org.apache.felix.https.keystore.key.password',
        type             => 'String',
        value            => $keystore_password,
        run_mode         => $run_mode,
        config_node_name => 'org.apache.felix.http',
        aem_username     => $aem_username,
        aem_password     => $aem_password,
        aem_id           => $aem_id,
      } -> exec { "[${aem_id}] Wait org.apache.felix.https.keystore.key.password property":
        command => 'sleep 5',
        path    => ['/usr/bin', '/usr/sbin', '/bin'],
      } -> aem_aem { "[${aem_id}] Wait until aem health check is ok org.apache.felix.https.keystore.key.password property":
        ensure       => aem_health_check_is_ok,
        tags         => 'deep',
        aem_username => $aem_username,
        aem_password => $aem_password,
        aem_id       => $aem_id,
      } -> aem_aem { "[${aem_id}] Wait until org.apache.felix.https.keystore.key.password property is set":
        ensure       => login_page_is_ready,
        aem_username => $aem_username,
        aem_password => $aem_password,
        aem_id       => $aem_id,
      } -> aem_config_property { "[${aem_id}] Create org.apache.felix.https.truststore property":
        ensure           => present,
        name             => 'org.apache.felix.https.truststore',
        type             => 'String',
        value            => $truststore,
        run_mode         => $run_mode,
        config_node_name => 'org.apache.felix.http',
        aem_username     => $aem_username,
        aem_password     => $aem_password,
        aem_id           => $aem_id,
      } -> exec { "[${aem_id}] Wait org.apache.felix.https.truststore property":
        command => 'sleep 5',
        path    => ['/usr/bin', '/usr/sbin', '/bin'],
      } -> aem_aem { "[${aem_id}] Wait until aem health check is ok org.apache.felix.https.truststore property":
        ensure       => aem_health_check_is_ok,
        tags         => 'deep',
        aem_username => $aem_username,
        aem_password => $aem_password,
        aem_id       => $aem_id,
      } -> aem_aem { "[${aem_id}] Wait until org.apache.felix.https.truststore property is set":
        ensure       => login_page_is_ready,
        aem_username => $aem_username,
        aem_password => $aem_password,
        aem_id       => $aem_id,
      } -> aem_config_property { "[${aem_id}] Create org.apache.felix.https.truststore.password property":
        ensure           => present,
        name             => 'org.apache.felix.https.truststore.password',
        type             => 'String',
        value            => $truststore_password,
        run_mode         => $run_mode,
        config_node_name => 'org.apache.felix.http',
        aem_username     => $aem_username,
        aem_password     => $aem_password,
        aem_id           => $aem_id,
      } -> exec { "[${aem_id}] Wait org.apache.felix.https.truststore.password property":
        command => 'sleep 5',
        path    => ['/usr/bin', '/usr/sbin', '/bin'],
      } -> aem_aem { "[${aem_id}] Wait until aem health check is ok org.apache.felix.https.truststore.password property":
        ensure       => aem_health_check_is_ok,
        tags         => 'deep',
        aem_username => $aem_username,
        aem_password => $aem_password,
        aem_id       => $aem_id,
      } -> aem_aem { "[${aem_id}] Wait until org.apache.felix.https.truststore.password property is set":
        ensure       => login_page_is_ready,
        aem_username => $aem_username,
        aem_password => $aem_password,
        aem_id       => $aem_id,
      } -> aem_config_property { "[${aem_id}] Create org.apache.felix.https.nio property":
        ensure           => present,
        name             => 'org.apache.felix.https.nio',
        type             => 'Boolean',
        value            => true,
        run_mode         => $run_mode,
        config_node_name => 'org.apache.felix.http',
        aem_username     => $aem_username,
        aem_password     => $aem_password,
        aem_id           => $aem_id,
      } -> exec { "[${aem_id}] Wait org.apache.felix.https.nio property":
        command => 'sleep 5',
        path    => ['/usr/bin', '/usr/sbin', '/bin'],
      } -> aem_aem { "[${aem_id}] Wait until aem health check is ok org.apache.felix.https.nio property":
        ensure       => aem_health_check_is_ok,
        tags         => 'deep',
        aem_username => $aem_username,
        aem_password => $aem_password,
        aem_id       => $aem_id,
      } -> aem_aem { "[${aem_id}] Wait until org.apache.felix.https.nio property":
        ensure       => login_page_is_ready,
        aem_username => $aem_username,
        aem_password => $aem_password,
        aem_id       => $aem_id,
      } -> aem_config_property { "[${aem_id}] Create org.apache.felix.https.enable property":
        ensure           => present,
        name             => 'org.apache.felix.https.enable',
        type             => 'Boolean',
        value            => true,
        run_mode         => $run_mode,
        config_node_name => 'org.apache.felix.http',
        aem_username     => $aem_username,
        aem_password     => $aem_password,
        aem_id           => $aem_id,
      } -> exec { "[${aem_id}] Wait org.apache.felix.https.enable property":
        command => 'sleep 5',
        path    => ['/usr/bin', '/usr/sbin', '/bin'],
      } -> aem_aem { "[${aem_id}] Wait until aem health check is ok org.apache.felix.https.enable property":
        ensure       => aem_health_check_is_ok,
        tags         => 'deep',
        aem_username => $aem_username,
        aem_password => $aem_password,
        aem_id       => $aem_id,
      } -> aem_aem { "[${aem_id}] Wait until org.apache.felix.https.enable property is set":
        ensure       => login_page_is_ready,
        aem_username => $aem_username,
        aem_password => $aem_password,
        aem_id       => $aem_id,
      }
    }
    default: {
    fail('SSL methods can only be of types: ( granite | jetty )')
    }
  }
}
