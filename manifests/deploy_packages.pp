class aem_resources::deploy_packages(
  $packages,
  $path = '/tmp/aem_packages'
){

  $packages.each | Integer $index, Hash $package| {

      aem_package { "${package['name']}-${package['version']} Package" :
        ensure    => $package[ensure],
        name      => $package[name],
        group     => $package[group],
        version   => $package[version],
        path      => "${path}/${package['group']}/${package['name']}/${package['version']}",
        replicate => $package[replicate],
        activate  => $package[activate],
        force     => $package[force],
      }

  }

}
