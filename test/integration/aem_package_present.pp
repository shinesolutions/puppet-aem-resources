aem_package { 'Install AEM6.2 hotfix 12785':
  ensure    => present,
  name      => 'cq-6.2.0-hotfix-12785',
  group     => 'adobe/cq620/hotfix',
  version   => '7.0',
  path      => '/tmp/',
  replicate => true,
  activate  => false,
  force     => true,
}
