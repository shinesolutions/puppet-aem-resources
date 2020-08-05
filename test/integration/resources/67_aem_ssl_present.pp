aem_ssl { 'Enable Granite SSL Config':
  ensure                => present,
  https_hostname        => 'localhost',
  https_port            => 5432,
  keystore_password     => 'somekeystorepassword',
  truststore_password   => 'sometruststorepassword',
  privatekey_file_path  => '/tmp/shinesolutions/puppet-aem-resources/cert_ssl.der',
  certificate_file_path => '/tmp/shinesolutions/puppet-aem-resources/cert_ssl.crt',
}

aem_ssl { 'Remove Granite SSL Config':
  ensure => absent
}
