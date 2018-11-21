aem_certificate { 'Add certificate by variable':
  ensure => present,
  file   => '/tmp/shinesolutions/puppet-aem-resources/saml.crt'
}
