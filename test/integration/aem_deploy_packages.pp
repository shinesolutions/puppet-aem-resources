
$packages = [
  {
    ensure    => present,
    name      => 'somepackage',
    version   => '1.2.3',
    group     => 'somepackagegroup',
    replicate => true,
    activate  => false,
    force     => true
  }
]

class { 'aem_resources::deploy_packages':
  packages => $packages,
  path     => '/tmp/puppet-aem-resources',
}
