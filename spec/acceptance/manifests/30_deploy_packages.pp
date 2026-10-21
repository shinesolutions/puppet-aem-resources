$packages = [
  {
    ensure    => present,
    name      => 'somepackage',
    version   => '1.2.3',
    group     => 'somepackagegroup',
    replicate => true,
    activate  => true,
    force     => true,
  }
]

# NOTE: to override port number for the scenario below, specify `author_port` instead of `aem_port`
aem_resources::deploy_packages { 'Deploy packages':
  packages => $packages,
  aem_id   => 'author',
  path     => '/tmp/shinesolutions/puppet-aem-resources/',
}
