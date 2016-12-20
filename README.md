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

Flush agent

    aem_flush_agent { 'Create flush agent':
      ensure        => present,
      name          => 'some-flush-agent',
      run_mode      => 'author',
      title         => 'Some Flush Agent Title',
      description   => 'Some flush agent description',
      dest_base_url => 'http://somehost:8080',
      force         => true,
    }

    aem_flush_agent { 'Delete flush agent':
      ensure   => absent,
      name     => 'some-flush-agent',
      run_mode => 'author',
    }

Repository

    aem_repository { 'Block repository writes':
      ensure => writes_blocked,
    }

    aem_repository { 'Unblock repository writes':
      ensure => writes_unblocked,
    }
