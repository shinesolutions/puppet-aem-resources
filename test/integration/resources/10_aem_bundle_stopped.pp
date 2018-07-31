aem_bundle { 'Stop webdav bundle':
  ensure => stopped,
  name   => 'org.apache.sling.jcr.webdav',
}

# NOTE: to override port number for the scenario below, specify `author_port` instead of `aem_port`
aem_bundle { 'Stop webdav bundle again':
  ensure => stopped,
  name   => 'org.apache.sling.jcr.webdav',
  aem_id => 'author',
}
