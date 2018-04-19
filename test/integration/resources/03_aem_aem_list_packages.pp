aem_aem { 'List packages by groups':
  ensure         => packages_listed,
  run_mode       => 'author',
  package_groups => ['shinesolutions'],
}
