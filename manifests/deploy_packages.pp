class aem_resources::deploy_packages (
  $packages,
  $path = '/tmp/shinesolutions/puppet-aem-resources',
  $sleep_seconds = 10,
  $aem_id = undef,
) {

  $packages.each | Integer $index, Hash $package| {

    $final_sleep_seconds = pick(
      $package['sleep_seconds'],
      $sleep_seconds,
    )

    aem_package { "Deploy package ${package['group']}/${package['name']}-${package['version']}":
      ensure    => present,
      name      => $package[name],
      group     => $package[group],
      version   => $package[version],
      path      => "${path}/${package['group']}",
      replicate => $package[replicate],
      activate  => $package[activate],
      force     => $package[force],
      aem_id    => $aem_id,
    }
    -> exec { "Wait post Deploy package ${package['group']}/${package['name']}-${package['version']}":
      command     => "sleep ${final_sleep_seconds}",
      path        => ['/usr/bin', '/usr/sbin', '/bin'],
      timeout     => 0,
      refreshonly => true,
    }

    aem_aem { "Wait until login page is ready post Deploy package ${package['group']}/${package['name']}-${package['version']}":
      ensure                     => login_page_is_ready,
      retries_max_tries          => 60,
      retries_base_sleep_seconds => 5,
      retries_max_sleep_seconds  => 5,
      require                    => Exec["Wait post Deploy package ${package['group']}/${package['name']}-${package['version']}"],
      aem_id                     => $aem_id,
    } -> aem_aem { "Wait until aem health check is ok post Deploy package ${package['group']}/${package['name']}-${package['version']}":
      ensure                     => aem_health_check_is_ok,
      tags                       => 'deep',
      retries_max_tries          => 60,
      retries_base_sleep_seconds => 5,
      retries_max_sleep_seconds  => 5,
      aem_id                     => $aem_id,
    }

  }

}
