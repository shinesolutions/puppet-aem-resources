aem_bundle { 'Stop webdav bundle':
  ensure => stopped,
  name   => 'org.apache.sling.jcr.webdav',
}

aem_bundle { 'Stop webdav bundle again':
  ensure => stopped,
  name   => 'org.apache.sling.jcr.webdav',
  aem_id => 'test-author',
}
