$packages = [
  {
    ensure    => present,
    name      => 'somepackage',
    version   => '1.2.3',
    group     => 'somepackagegroup',
    replicate => true,
    activate  => true,
    force     => true
  }
]

aem_resources::deploy_packages { 'Deploy packages':
  packages => $packages,
  path     => '/tmp/shinesolutions/puppet-aem-resources/',
}
