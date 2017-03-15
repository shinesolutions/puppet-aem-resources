aem_package { 'Install package':
  ensure             => present,
  name               => 'somepackage',
  version            => '1.2.3',
  group              => 'somepackagegroup',
  path               => '/tmp/shinesolutions/puppet-aem-resources/',
  replicate          => true,
  activate           => false,
  force              => true,
  max_tries          => 60,
  base_sleep_seconds => 5,
  max_sleep_seconds  => 5,
}
