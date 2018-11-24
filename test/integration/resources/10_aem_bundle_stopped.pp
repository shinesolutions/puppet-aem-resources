# NOTE: to override port number for the scenario below, specify `author_port` as well as `aem_port`
# `aem_port` will be consumed by default, while `author_port` will override the value when `aem_id` is set to `author`
aem_bundle { 'Stop webdav bundle':
  ensure => stopped,
  name   => 'org.apache.sling.jcr.webdav',
}
aem_bundle { 'Stop webdav bundle again':
  ensure => stopped,
  name   => 'org.apache.sling.jcr.webdav',
  aem_id => 'author',
}
