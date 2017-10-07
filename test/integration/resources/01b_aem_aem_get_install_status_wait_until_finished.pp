aem_aem { 'Wait until install status is finished':
  ensure                     => install_status_is_finished,
  retries_max_tries          => 60,
  retries_base_sleep_seconds => 5,
  retries_max_sleep_seconds  => 5,
}
