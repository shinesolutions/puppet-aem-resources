aem_aem { 'Wait until login page is ready':
  ensure                     => login_page_is_ready,
  retries_max_tries          => 60,
  retries_base_sleep_seconds => 5,
  retries_max_sleep_seconds  => 5,
}
