aem_aem { 'Wait until CRX Package Manager is ready':
  ensure                     => aem_package_manager_is_ready,
  retries_max_tries          => 60,
  retries_base_sleep_seconds => 5,
  retries_max_sleep_seconds  => 5,
}
