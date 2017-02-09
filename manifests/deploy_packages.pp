class aem_resources::deploy_packages(
  $packages,
  $path = '/tmp/shinesolutions/puppet-aem-resources',
){

  $packages.each | Integer $index, Hash $package| {

      aem_package { "Deploy package ${package['group']}/${package['name']}-${package['version']}" :
        ensure    => $package[ensure],
        name      => $package[name],
        group     => $package[group],
        version   => $package[version],
        path      => "${path}/${package['group']}",
        replicate => $package[replicate],
        activate  => $package[activate],
        force     => $package[force],
      }

  }

}
