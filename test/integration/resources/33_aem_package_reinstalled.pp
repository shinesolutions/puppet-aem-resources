aem_package { 'Install package':
  ensure                     => reinstalled,
  name                       => 'somepackage',
  version                    => '1.2.3',
  group                      => 'somepackagegroup',
  path                       => '/tmp/shinesolutions/puppet-aem-resources/',
  replicate                  => true,
  activate                   => false,
  force                      => true,
  retries_max_tries          => 60,
  retries_base_sleep_seconds => 5,
  retries_max_sleep_seconds  => 5,
}
