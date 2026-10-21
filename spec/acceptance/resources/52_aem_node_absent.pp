aem_aem { 'Wait until login page is ready':
  ensure => login_page_is_ready,
}

aem_node { 'Delete http OSGI config node':
  ensure => absent,
  name   => 'org.apache.felix.http',
  path   => '/apps/system/config',
}
