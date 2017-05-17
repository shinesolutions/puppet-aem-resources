aem_bundle { 'Stop webdav bundle':
  ensure => stopped,
  name   => 'org.apache.sling.jcr.webdav',
}
