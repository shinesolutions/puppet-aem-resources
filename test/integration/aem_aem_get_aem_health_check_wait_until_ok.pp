aem_aem { 'Wait until health is ok':
  ensure                     => aem_health_check_is_ok,
  tags                       => 'deep',
  combine_tags_or            => false,
  retries_max_tries          => 60,
  retries_base_sleep_seconds => 5,
  retries_max_sleep_seconds  => 5,
}
