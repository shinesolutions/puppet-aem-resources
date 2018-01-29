aem_resources::disable_crxde { 'Disable CRXDE':
  run_mode => 'author',
}

aem_bundle_alias { 'Start davex bundle':
  ensure => started,
  name   => 'org.apache.sling.jcr.davex',
}
