[![Build Status](https://img.shields.io/travis/shinesolutions/puppet-aem-resources.svg)](http://travis-ci.org/shinesolutions/puppet-aem-resources)

Puppet AEM Resources
--------------------

Usage
-----

Bundle

    aem_bundle { 'Stop webdav bundle':
      ensure => stopped,
      name   => 'org.apache.sling.jcr.webdav',
    }

    aem_bundle { 'Start webdav bundle':
      ensure => started,
      name   => 'org.apache.sling.jcr.webdav',
    }
