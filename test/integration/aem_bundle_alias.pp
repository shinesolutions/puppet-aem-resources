aem_bundle_alias { 'Stop webdav bundle':
  ensure => stopped,
  name   => 'org.apache.sling.jcr.webdav',
}

aem_bundle { 'Start webdav bundle':
  ensure => started,
  name   => 'org.apache.sling.jcr.webdav',
}
