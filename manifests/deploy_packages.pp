class aem_resources::deploy_packages (
  $packages,
  $path          = '/tmp/shinesolutions/puppet-aem-resources',
  $sleep_seconds = 10
) {

  $packages.each | Integer $index, Hash $package| {

    aem_package { "Deploy package ${package['group']}/${package['name']}-${package['version']}":
      ensure    => present,
      name      => $package[name],
      group     => $package[group],
      version   => $package[version],
      path      => "${path}/${package['group']}",
      replicate => $package[replicate],
      activate  => $package[activate],
      force     => $package[force],
    }

    $final_sleep_seconds = pick(
      $package['sleep_seconds'],
      $sleep_seconds,
    )

    exec { "Wait post Deploy package ${package['group']}/${package['name']}-${package['version']}":
      command => "sleep ${final_sleep_seconds}",
      path    => ['/usr/bin', '/usr/sbin', '/bin'],
      timeout => 0,
      require => Aem_package["Deploy package ${package['group']}/${package['name']}-${package['version']}"],
    }

    aem_aem { "Wait until login page is ready post Deploy package ${package['group']}/${package['name']}-${package['version']}":
      ensure                     => login_page_is_ready,
      retries_max_tries          => 60,
      retries_base_sleep_seconds => 5,
      retries_max_sleep_seconds  => 5,
      require                    => Exec["Wait post Deploy package ${package['group']}/${package['name']}-${package['version']}"],
    } -> aem_aem { "Wait until aem health check is ok post Deploy package ${package['group']}/${package['name']}-${package['version']}":
      ensure                     => aem_health_check_is_ok,
      tags                       => 'deep',
      retries_max_tries          => 60,
      retries_base_sleep_seconds => 5,
      retries_max_sleep_seconds  => 5,
    }

  }

}
