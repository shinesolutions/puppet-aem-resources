define aem_resources::deploy_packages (
  $packages,
  $path          = '/tmp/shinesolutions/puppet-aem-resources',
  $sleep_seconds = 10,
  $aem_id        = undef,
  $aem_username  = undef,
  $aem_password  = undef,
) {

  $packages.each | Integer $index, Hash $package| {

    $_aem_id = pick(
      $package[aem_id],
      $aem_id,
      'author'
      )

    $final_sleep_seconds = pick(
      $package['sleep_seconds'],
      $sleep_seconds,
    )

    aem_package { "[${_aem_id}] Deploy package ${package['group']}/${package['name']}-${package['version']}":
      ensure       => present,
      name         => $package[name],
      group        => $package[group],
      version      => $package[version],
      path         => "${path}/${_aem_id}/${package['group']}",
      replicate    => $package[replicate],
      activate     => $package[activate],
      force        => $package[force],
      aem_username => $aem_username,
      aem_password => $aem_password,
      aem_id       => $_aem_id,
    } -> exec { "[${_aem_id}] Wait post Deploy package ${package['group']}/${package['name']}-${package['version']}":
      command => "sleep ${final_sleep_seconds}",
      path    => ['/usr/bin', '/usr/sbin', '/bin'],
      timeout => 0
    }

    aem_aem { "[${_aem_id}] Wait until login page is ready post Deploy package ${package['group']}/${package['name']}-${package['version']}":
      ensure                     => login_page_is_ready,
      retries_max_tries          => 60,
      retries_base_sleep_seconds => 5,
      retries_max_sleep_seconds  => 5,
      require                    => Exec["[${_aem_id}] Wait post Deploy package ${package['group']}/${package['name']}-${package['version']}"],
      aem_username               => $aem_username,
      aem_password               => $aem_password,
      aem_id                     => $_aem_id,
    } -> aem_aem { "[${_aem_id}] Wait until aem health check is ok post Deploy package ${package['group']}/${package['name']}-${package['version']}":
      ensure                     => aem_health_check_is_ok,
      tags                       => 'deep',
      retries_max_tries          => 60,
      retries_base_sleep_seconds => 5,
      retries_max_sleep_seconds  => 5,
      aem_username               => $aem_username,
      aem_password               => $aem_password,
      aem_id                     => $_aem_id,
    }

  }

}
