aem_repository { 'Block repository writes':
  ensure => writes_blocked,
}

aem_repository { 'Unblock repository writes':
  ensure => writes_unblocked,
}
