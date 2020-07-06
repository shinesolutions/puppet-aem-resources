[![Build Status](https://img.shields.io/travis/shinesolutions/puppet-aem-resources.svg)](http://travis-ci.org/shinesolutions/puppet-aem-resources)
[![Published Version](https://img.shields.io/puppetforge/v/shinesolutions/aem_resources.svg)](http://forge.puppet.com/shinesolutions/aem_resources)
[![Downloads Count](https://img.shields.io/puppetforge/dt/shinesolutions/aem_resources.svg)](http://forge.puppet.com/shinesolutions/aem_resources)
[![Known Vulnerabilities](https://snyk.io/test/github/shinesolutions/puppet-aem-resources/badge.svg)](https://snyk.io/test/github/shinesolutions/puppet-aem-resources)

Puppet AEM Resources
--------------------

A Puppet module for provisioning [Adobe Experience Manager (AEM)](http://www.adobe.com/au/marketing-cloud/enterprise-content-management.html) resources.

Learn more about Puppet AEM Resources:

* [Installation](https://github.com/shinesolutions/puppet-aem-resources#installation)
* [Usage](https://github.com/shinesolutions/puppet-aem-resources#usage)
* [Multi AEM Instances](https://github.com/shinesolutions/puppet-aem-resources#multi-aem-instances)
* [Multi AEM Versions](https://github.com/shinesolutions/puppet-aem-resources#multi-aem-versions)
* [Alias](https://github.com/shinesolutions/puppet-aem-resources#alias)
* [Upgrade](https://github.com/shinesolutions/puppet-aem-resources#upgrade)
* [Testing](https://github.com/shinesolutions/puppet-aem-resources#testing)

Puppet AEM Resources is part of [AEM OpenCloud](https://aemopencloud.io) platform but it can be used as a stand-alone.

Installation
------------

    puppet module install shinesolutions-aem_resources

Or via a Puppetfile:

    mod 'shinesolutions/aem_resources'

If you want to use the master version:

    mod 'shinesolutions/aem_resources', :git => 'https://github.com/shinesolutions/puppet-aem-resources'

And because [PUP-3386](https://tickets.puppetlabs.com/browse/PUP-3386) hasn't been implemented, you have to install [ruby_aem](https://github.com/shinesolutions/ruby_aem) prior to using aem_resource Puppet module.

    package { 'ruby_aem':
      ensure   => '3.8.0',
      provider => 'puppet_gem',
    }

Configuration
-------------

AEM username, password, protocol, host, port, and debug can be set via environment variables or a configuration file.

Environment variables have `aem_` prefix, e.g. `aem_username`, `aem_password`, `aem_protocol`, `aem_host`, `aem_port`, `aem_timeout`, and `aem_debug`.

Configuration file should be named `aem.yaml` and be placed under [Puppet config directory](https://docs.puppet.com/puppet/latest/dirs_confdir.html). Example config file:

    ---
    :username: 'admin'
    :password: 'admin'
    :protocol: 'http'
    :host: 'localhost'
    :port: 4502
    :timeout: 300
    :debug: False

If a configuration property is not set, then it will use the default value set in [ruby_aem](https://github.com/shinesolutions/ruby_aem).

However, if the invocation specifies an `aem_id` attribute, then the value of that attribute will be used to identify the environment variables and configuration file. For example:

    aem_bundle {
      ...
      aem_id => 'myaem',
      ...
    }

The invocation above will use environment variables with `myaem_` prefix, e.g. `myaem_username`, and it will use a configuration file named `myaem.yaml` under Puppet config directory.

It is also possible to specify username and password at invocation level by specifying `aem_username` and `aem_password` attributes. For example:

    aem_bundle {
      ...
      aem_username => 'myusername',
      aem_password => 'mypassword',
      ...
    }

Usage
-----

AEM

    aem_aem { 'Wait until login page is ready':
      ensure                     => login_page_is_ready,
      retries_max_tries          => 60,
      retries_base_sleep_seconds => 5,
      retries_max_sleep_seconds  => 5,
    }

    aem_aem { 'Wait until CRX Package Manager is ready':
      ensure                     => aem_package_manager_is_ready,
      retries_max_tries          => 60,
      retries_base_sleep_seconds => 5,
      retries_max_sleep_seconds  => 5,
    }

    # this requires aem-healthcheck package to be installed
    # https://github.com/shinesolutions/aem-healthcheck
    aem_aem { 'Wait until health is ok':
      ensure                     => aem_health_check_is_ok,
      tags                       => 'deep',
      combine_tags_or            => false,
      retries_max_tries          => 60,
      retries_base_sleep_seconds => 5,
      retries_max_sleep_seconds  => 5,
    }

    aem_aem { 'Wait until install status is finished':
      ensure                     => install_status_is_finished,
      retries_max_tries          => 60,
      retries_base_sleep_seconds => 5,
      retries_max_sleep_seconds  => 5,
    }

    aem_aem { 'Remove all agents':
      ensure   => all_agents_removed,
      run_mode => 'author',
    }

Authorizable Keystore

    aem_authorizable_keystore { "Create new keystore for user authentication-service":
      ensure            => present,
      aem_id            => 'author',
      aem_username      => 'admin',
      aem_password      => 'admin',
      authorizable_id   => 'authentication-service',
      intermediate_path => '/home/users/system',
      password          => 'password1'
    }

    aem_authorizable_keystore { "Archive keystore for user authentication-service to a specific path":
      ensure            => archived,
      aem_id            => 'author',
      aem_username      => 'admin',
      aem_password      => 'admin',
      authorizable_id   => 'authentication-service',
      intermediate_path => '/home/users/system',
      path              => '/tmp'
    }

    aem_authorizable_keystore { "Archive keystore for user authentication-service to a specific path":
      ensure            => archived,
      aem_id            => 'author',
      aem_username      => 'admin',
      aem_password      => 'admin',
      authorizable_id   => 'authentication-service',
      intermediate_path => '/home/users/system',
      file              => '/tmp/store.p12'
    }

    aem_authorizable_keystore { "Remove keystore for user authentication-service":
      ensure            => absent,
      aem_id            => 'author',
      aem_username      => 'admin',
      aem_password      => 'admin',
      authorizable_id   => 'authentication-service',
      intermediate_path => '/home/users/system',
    }

Authorizable Keystore Certificate

    aem_certificate_chain { "Add certificate to user authentication-service keystore with certificate provided as file":
      ensure                      => present,
      aem_id                      => 'author',
      aem_username                => 'admin',
      aem_password                => 'admin',
      authorizable_id             => 'authentication-service',
      intermediate_path           => '/home/users/system',
      private_key_alias           => 'alias_123'
      private_key_file_path       => '/tmp/private_key_pkcs8.der'
      certificate_chain_file_path => '/tmp/cert_pem.crt'
    }

    aem_certificate_chain { "Remove a certificate from User1 keystore":
      ensure            => present,
      aem_id            => 'author',
      aem_username      => 'admin',
      aem_password      => 'admin',
      authorizable_id   => 'authentication-service',
      intermediate_path => '/home/users/system',
      private_key_alias => 'alias_123'
    }

Bundle

    aem_bundle { 'Stop webdav bundle':
      ensure => stopped,
      name   => 'org.apache.sling.jcr.webdav',
    }

    aem_bundle { 'Start webdav bundle':
      ensure => started,
      name   => 'org.apache.sling.jcr.webdav',
    }

Certificate

    aem_certificate { "Add certificate by file name":
      ensure       => present,
      aem_id       => 'author',
      aem_username => 'admin',
      aem_password => 'admin',
      file         => '/tmp/cert.crt'
    }

    aem_certificate { "Force adding certificate by file name":
      ensure       => present,
      aem_id       => 'author',
      aem_username => 'admin',
      aem_password => 'admin',
      file         => '/tmp/cert.crt',
      force        => true
    }

    aem_certificate { "Archive certificate via serial number to a specified file path":
      ensure              => archived,
      aem_id              => 'author',
      aem_username        => 'admin',
      aem_password        => 'admin',
      truststore_password => 'admin'
      serial              => '1234567890'
      file                => '/tmp/cert.crt',
    }

    aem_certificate { "Remove certificate by file name":
      ensure       => absent,
      aem_id       => 'author',
      aem_username => 'admin',
      aem_password => 'admin',
      file         => '/tmp/cert.crt'
    }

    aem_certificate { "Remove certificate by serial number":
      ensure       => absent,
      aem_id       => 'author',
      aem_username => 'admin',
      aem_password => 'admin',
      serial       => '1234567890'
    }

Config property

    aem_config_property { 'Create https.enable property':
      ensure    => present,
      name      => 'org.apache.felix.https.enable',
      type      => 'Boolean',
      value     => true,
      run_mode  => 'author',
      node_name => 'org.apache.felix.http',
    }

Flush agent

    aem_flush_agent { 'Create flush agent':
      ensure        => present,
      name          => 'some-flush-agent',
      run_mode      => 'author',
      title         => 'Some Flush Agent Title',
      description   => 'Some flush agent description',
      dest_base_url => 'http://somehost:8080',
      log_level     => 'info',
      retry_delay   => 60000,
      force         => true,
    }

    aem_flush_agent { 'Delete flush agent':
      ensure   => absent,
      name     => 'some-flush-agent',
      run_mode => 'author',
    }

Group

    aem_group { 'Create staff group':
      ensure => present,
      name   => 'staff',
      path   => '/home/groups/s',
    }

    aem_group { 'Create contractor group':
      ensure => present,
      name   => 'contractor',
      path   => '/home/groups/c',
    }

    aem_group { 'Create contractor group as a member of staff group':
      ensure            => present,
      name              => 'contractor',
      path              => '/home/groups/c',
      parent_group_name => 'staff',
      parent_group_path => '/home/groups/s',
    }

    aem_group { 'Create staff group and add contractor group as a member':
      ensure            => present,
      name              => 'staff',
      path              => '/home/groups/s',
      member_group_name => 'contractor',
      member_group_path => '/home/groups/c',
    }

    aem_group { 'Delete staff group':
      ensure => absent,
      name   => 'staff',
      path   => '/home/groups/s',
    }

Node

    aem_node { 'Create http OSGI config node':
      ensure => present,
      name   => 'org.apache.felix.http',
      path   => '/apps/system/config',
      type   => 'sling:OsgiConfig',
    }

    aem_node { 'Delete http OSGI config node':
      ensure => absent,
      name   => 'org.apache.felix.http',
      path   => '/apps/system/config',
    }

Package

    aem_package { 'Install AEM6.2 hotfix 12785':
      ensure    => present,
      name      => 'cq-6.2.0-hotfix-12785',
      group     => 'adobe/cq620/hotfix',
      version   => '7.0',
      path      => '/tmp/',
      replicate => false,
      activate  => true,
      force     => true,
    }

    aem_package { 'Archive Geometrixx apps':
      ensure  => archived,
      name    => 'somearchivedpackage',
      group   => 'somepackagegroup',
      version => '1.2.3',
      path    => '/tmp/',
      filter  => '[{"root":"/apps/geometrixx","rules":[]},{"root":"/apps/geometrixx-common","rules":[]}]',
    }

Path

    aem_path { 'Activate /etc/designs/cloudservices/':
      ensure => is_activated,
      name   => '/etc/designs/cloudservices/',
    }

    aem_path { 'Delete /etc/designs/somepath/':
      ensure => absent,
      name   => '/etc/designs/somepath/',
    }

Replication agent

    aem_replication_agent { 'Create replication agent':
      ensure             => present,
      name               => 'some-replication-agent',
      run_mode           => 'author',
      title              => 'Some Replication Agent Title',
      description        => 'Some replication agent description',
      dest_base_url      => 'http://somehost:8080',
      transport_user     => 'someuser',
      transport_password => 'somepass',
      log_level          => 'info',
      retry_delay        => 60000,
      force              => true,
    }

    aem_replication_agent { 'Delete replication agent':
      ensure   => absent,
      name     => 'some-replication-agent',
      run_mode => 'author',
    }

Outbox replication agent

    aem_outbox_replication_agent { 'Create outbox replication agent':
      ensure      => present,
      name        => 'some-outbox-replication-agent',
      run_mode    => 'publish',
      title       => 'Some Outbox Replication Agent Title',
      description => 'Some outbox replication agent description',
      user_id     => 'admin',
      log_level   => 'info',
      force       => true,
    }

    aem_outbox_replication_agent { 'Delete outbox replication agent':
      ensure   => absent,
      name     => 'some-outbox-replication-agent',
      run_mode => 'publish',
    }

Repository

    aem_repository { 'Block repository writes':
      ensure => writes_blocked,
    }

    aem_repository { 'Unblock repository writes':
      ensure => writes_unblocked,
    }

Saml

    aem_saml { 'Create SAML configuration for AEM 6.2 with certificate provided via idp_cert_alias parameter':
      ensure                     => present,
      aem_username               => 'admin',
      aem_password               => 'admin',
      aem_id                     => 'author',
      key_store_password         => 'admin',
      service_ranking            => 5002,
      idp_http_redirect          => true,
      create_user                => true,
      default_redirect_url       => '/sites.html',
      user_id_attribute          => 'NameID',
      default_groups             => ['def-groups'],
      idp_cert_alias             => 'certalias___1542770831396',
      add_group_memberships      => true,
      path                       => ['/'],
      synchronize_attributes     => [
      'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname\=profile/givenName',
      'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname\=profile/familyName',
      'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress\=profile/email'
      ],
      group_membership_attribute => 'http://temp/variable/aem-groups',
      idp_url                    => 'https://federation.prod.com/adfs/ls/IdpInitiatedSignOn.aspx?RequestBinding\=HTTPPost&loginToRp\=https://prod-aemauthor.com/saml_login',
      logout_url                 => 'https://federation.prod.com/adfs/ls/IdpInitiatedSignOn.aspx',
      service_provider_entity_id => 'https://prod-aemauthor.com/saml_login',
      handle_logout              => true,
      sp_private_key_alias       => '',
      use_encryption             => false,
      name_id_format             => 'urn:oasis:names:tc:SAML:2.0:nameid-format:transient'
    }

    aem_saml { 'Create SAML configuration for AEM 6.3 with certificate provided via idp_cert_alias parameter':
      ensure                     => present,
      aem_username               => 'admin',
      aem_password               => 'admin',
      aem_id                     => 'author',
      key_store_password         => 'admin',
      service_ranking            => 5002,
      idp_http_redirect          => true,
      create_user                => true,
      default_redirect_url       => '/sites.html',
      user_id_attribute          => 'NameID',
      default_groups             => ['def-groups'],
      idp_cert_alias             => 'certalias___1542770831396',
      add_group_memberships      => true,
      path                       => ['/'],
      synchronize_attributes     => [
      'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname\=profile/givenName',
      'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname\=profile/familyName',
      'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress\=profile/email'
      ],
      clock_tolerance            => 60,
      group_membership_attribute => 'http://temp/variable/aem-groups',
      idp_url                    => 'https://federation.prod.com/adfs/ls/IdpInitiatedSignOn.aspx?RequestBinding\=HTTPPost&loginToRp\=https://prod-aemauthor.com/saml_login',
      logout_url                 => 'https://federation.prod.com/adfs/ls/IdpInitiatedSignOn.aspx',
      service_provider_entity_id => 'https://prod-aemauthor.com/saml_login',
      handle_logout              => true,
      sp_private_key_alias       => '',
      use_encryption             => false,
      name_id_format             => 'urn:oasis:names:tc:SAML:2.0:nameid-format:transient',
      digest_method 	           => 'http://www.w3.org/2001/04/xmlenc#sha256',
      signature_method	         => 'http://www.w3.org/2001/04/xmldsig-more#rsa-sha256'
    }

    aem_saml { 'Create SAML configuration for AEM 6.4 with certificate provided via idp_cert_alias parameter':
      ensure                     => present,
      aem_username               => 'admin',
      aem_password               => 'admin',
      aem_id                     => 'author',
      key_store_password         => 'admin',
      service_ranking            => 5002,
      idp_http_redirect          => true,
      create_user                => true,
      default_redirect_url       => '/sites.html',
      user_id_attribute          => 'NameID',
      default_groups             => ['def-groups'],
      idp_cert_alias             => 'certalias___1542770831396',
      add_group_memberships      => true,
      path                       => ['/'],
      synchronize_attributes     => [
      'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname\=profile/givenName',
      'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname\=profile/familyName',
      'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress\=profile/email'
      ],
      clock_tolerance            => 60,
      group_membership_attribute => 'http://temp/variable/aem-groups',
      idp_url                    => 'https://federation.prod.com/adfs/ls/IdpInitiatedSignOn.aspx?RequestBinding\=HTTPPost&loginToRp\=https://prod-aemauthor.com/saml_login',
      logout_url                 => 'https://federation.prod.com/adfs/ls/IdpInitiatedSignOn.aspx',
      service_provider_entity_id => 'https://prod-aemauthor.com/saml_login',
      handle_logout              => true,
      sp_private_key_alias       => '',
      use_encryption             => false,
      name_id_format             => 'urn:oasis:names:tc:SAML:2.0:nameid-format:transient',
      digest_method 	           => 'http://www.w3.org/2001/04/xmlenc#sha256',
      signature_method	         => 'http://www.w3.org/2001/04/xmldsig-more#rsa-sha256'
      user_intermediate_path     => '',
      assertion_consumer_service_url => ''
    }

    aem_saml { 'Create SAML configuration for AEM 6.2 with certificate provided via serial number':
      ensure                     => present,
      aem_username               => 'admin',
      aem_password               => 'admin',
      aem_id                     => 'author',
      key_store_password         => 'admin',
      service_ranking            => 5002,
      idp_http_redirect          => true,
      create_user                => true,
      default_redirect_url       => '/sites.html',
      user_id_attribute          => 'NameID',
      default_groups             => ['def-groups'],
      serial                     => '1234567890',
      add_group_memberships      => true,
      path                       => ['/'],
      synchronize_attributes     => [
      'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname\=profile/givenName',
      'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname\=profile/familyName',
      'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress\=profile/email'
      ],
      group_membership_attribute => 'http://temp/variable/aem-groups',
      idp_url                    => 'https://federation.prod.com/adfs/ls/IdpInitiatedSignOn.aspx?RequestBinding\=HTTPPost&loginToRp\=https://prod-aemauthor.com/saml_login',
      logout_url                 => 'https://federation.prod.com/adfs/ls/IdpInitiatedSignOn.aspx',
      service_provider_entity_id => 'https://prod-aemauthor.com/saml_login',
      handle_logout              => true,
      sp_private_key_alias       => '',
      use_encryption             => false,
      name_id_format             => 'urn:oasis:names:tc:SAML:2.0:nameid-format:transient'
    }

    aem_saml { 'Create SAML configuration for AEM 6.3 with certificate provided via serial number':
      ensure                     => present,
      aem_username               => 'admin',
      aem_password               => 'admin',
      aem_id                     => 'author',
      key_store_password         => 'admin',
      service_ranking            => 5002,
      idp_http_redirect          => true,
      create_user                => true,
      default_redirect_url       => '/sites.html',
      user_id_attribute          => 'NameID',
      default_groups             => ['def-groups'],
      serial                     => '1234567890',
      add_group_memberships      => true,
      path                       => ['/'],
      synchronize_attributes     => [
      'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname\=profile/givenName',
      'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname\=profile/familyName',
      'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress\=profile/email'
      ],
      clock_tolerance            => 60,
      group_membership_attribute => 'http://temp/variable/aem-groups',
      idp_url                    => 'https://federation.prod.com/adfs/ls/IdpInitiatedSignOn.aspx?RequestBinding\=HTTPPost&loginToRp\=https://prod-aemauthor.com/saml_login',
      logout_url                 => 'https://federation.prod.com/adfs/ls/IdpInitiatedSignOn.aspx',
      service_provider_entity_id => 'https://prod-aemauthor.com/saml_login',
      handle_logout              => true,
      sp_private_key_alias       => '',
      use_encryption             => false,
      name_id_format             => 'urn:oasis:names:tc:SAML:2.0:nameid-format:transient',
      digest_method 	           => 'http://www.w3.org/2001/04/xmlenc#sha256',
      signature_method	         => 'http://www.w3.org/2001/04/xmldsig-more#rsa-sha256'
    }

    aem_saml { 'Create SAML configuration for AEM 6.4 with certificate provided via serial number':
      ensure                     => present,
      aem_username               => 'admin',
      aem_password               => 'admin',
      aem_id                     => 'author',
      key_store_password         => 'admin',
      service_ranking            => 5002,
      idp_http_redirect          => true,
      create_user                => true,
      default_redirect_url       => '/sites.html',
      user_id_attribute          => 'NameID',
      default_groups             => ['def-groups'],
      serial                     => '1234567890',
      add_group_memberships      => true,
      path                       => ['/'],
      synchronize_attributes     => [
      'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname\=profile/givenName',
      'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname\=profile/familyName',
      'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress\=profile/email'
      ],
      clock_tolerance            => 60,
      group_membership_attribute => 'http://temp/variable/aem-groups',
      idp_url                    => 'https://federation.prod.com/adfs/ls/IdpInitiatedSignOn.aspx?RequestBinding\=HTTPPost&loginToRp\=https://prod-aemauthor.com/saml_login',
      logout_url                 => 'https://federation.prod.com/adfs/ls/IdpInitiatedSignOn.aspx',
      service_provider_entity_id => 'https://prod-aemauthor.com/saml_login',
      handle_logout              => true,
      sp_private_key_alias       => '',
      use_encryption             => false,
      name_id_format             => 'urn:oasis:names:tc:SAML:2.0:nameid-format:transient',
      digest_method 	           => 'http://www.w3.org/2001/04/xmlenc#sha256',
      signature_method	         => 'http://www.w3.org/2001/04/xmldsig-more#rsa-sha256'
      user_intermediate_path     => '',
      assertion_consumer_service_url => ''
    }

    aem_saml { 'Create SAML configuration for AEM 6.2 with certificate provided as a file':
      ensure                     => present,
      aem_username               => 'admin',
      aem_password               => 'admin',
      aem_id                     => 'author',
      key_store_password         => 'admin',
      service_ranking            => 5002,
      idp_http_redirect          => true,
      create_user                => true,
      default_redirect_url       => '/sites.html',
      user_id_attribute          => 'NameID',
      default_groups             => ['def-groups'],
      file                       => '/tmp/cert.crt',
      add_group_memberships      => true,
      path                       => ['/'],
      synchronize_attributes     => [
      'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname\=profile/givenName',
      'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname\=profile/familyName',
      'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress\=profile/email'
      ],
      group_membership_attribute => 'http://temp/variable/aem-groups',
      idp_url                    => 'https://federation.prod.com/adfs/ls/IdpInitiatedSignOn.aspx?RequestBinding\=HTTPPost&loginToRp\=https://prod-aemauthor.com/saml_login',
      logout_url                 => 'https://federation.prod.com/adfs/ls/IdpInitiatedSignOn.aspx',
      service_provider_entity_id => 'https://prod-aemauthor.com/saml_login',
      handle_logout              => true,
      sp_private_key_alias       => '',
      use_encryption             => false,
      name_id_format             => 'urn:oasis:names:tc:SAML:2.0:nameid-format:transient'
    }

    aem_saml { 'Create SAML configuration for AEM 6.3 with certificate provided as a file':
      ensure                     => present,
      aem_username               => 'admin',
      aem_password               => 'admin',
      aem_id                     => 'author',
      key_store_password         => 'admin',
      service_ranking            => 5002,
      idp_http_redirect          => true,
      create_user                => true,
      default_redirect_url       => '/sites.html',
      user_id_attribute          => 'NameID',
      default_groups             => ['def-groups'],
      file                       => '/tmp/cert.crt',
      add_group_memberships      => true,
      path                       => ['/'],
      synchronize_attributes     => [
      'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname\=profile/givenName',
      'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname\=profile/familyName',
      'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress\=profile/email'
      ],
      clock_tolerance            => 60,
      group_membership_attribute => 'http://temp/variable/aem-groups',
      idp_url                    => 'https://federation.prod.com/adfs/ls/IdpInitiatedSignOn.aspx?RequestBinding\=HTTPPost&loginToRp\=https://prod-aemauthor.com/saml_login',
      logout_url                 => 'https://federation.prod.com/adfs/ls/IdpInitiatedSignOn.aspx',
      service_provider_entity_id => 'https://prod-aemauthor.com/saml_login',
      handle_logout              => true,
      sp_private_key_alias       => '',
      use_encryption             => false,
      name_id_format             => 'urn:oasis:names:tc:SAML:2.0:nameid-format:transient',
      digest_method 	           => 'http://www.w3.org/2001/04/xmlenc#sha256',
      signature_method	         => 'http://www.w3.org/2001/04/xmldsig-more#rsa-sha256'
    }

    aem_saml { 'Create SAML configuration for AEM 6.4 with certificate provided as a file':
      ensure                     => present,
      aem_username               => 'admin',
      aem_password               => 'admin',
      aem_id                     => 'author',
      key_store_password         => 'admin',
      service_ranking            => 5002,
      idp_http_redirect          => true,
      create_user                => true,
      default_redirect_url       => '/sites.html',
      user_id_attribute          => 'NameID',
      default_groups             => ['def-groups'],
      file                       => '/tmp/cert.crt',
      add_group_memberships      => true,
      path                       => ['/'],
      synchronize_attributes     => [
      'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname\=profile/givenName',
      'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname\=profile/familyName',
      'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress\=profile/email'
      ],
      clock_tolerance            => 60,
      group_membership_attribute => 'http://temp/variable/aem-groups',
      idp_url                    => 'https://federation.prod.com/adfs/ls/IdpInitiatedSignOn.aspx?RequestBinding\=HTTPPost&loginToRp\=https://prod-aemauthor.com/saml_login',
      logout_url                 => 'https://federation.prod.com/adfs/ls/IdpInitiatedSignOn.aspx',
      service_provider_entity_id => 'https://prod-aemauthor.com/saml_login',
      handle_logout              => true,
      sp_private_key_alias       => '',
      use_encryption             => false,
      name_id_format             => 'urn:oasis:names:tc:SAML:2.0:nameid-format:transient',
      digest_method 	           => 'http://www.w3.org/2001/04/xmlenc#sha256',
      signature_method	         => 'http://www.w3.org/2001/04/xmldsig-more#rsa-sha256'
      user_intermediate_path     => '',
      assertion_consumer_service_url => ''
    }

    aem_saml { 'Remove SAML configuration':
      ensure                     => absent,
      aem_username               => 'admin',
      aem_password               => 'admin',
      aem_id                     => 'author',
    }

Truststore

    aem_truststore { "Create Truststore":
      ensure              => present,
      aem_id              => 'author',
      aem_username        => 'admin',
      aem_password        => 'admin',
      password            => 'admin'
    }

    aem_truststore { "Import Truststore from file provided via file":
      ensure              => present,
      aem_id              => 'author',
      aem_username        => 'admin',
      aem_password        => 'admin',
      password            => 'admin'
      file                => '/root/truststore.p12'
    }

    aem_truststore { "Archive Truststore to /root":
      ensure              => archived,
      aem_id              => 'author',
      aem_username        => 'admin',
      aem_password        => 'admin',
      path                => '/root'
    }

    aem_truststore { "Archive Truststore to /root/truststore.p12":
      ensure              => archived,
      aem_id              => 'author',
      aem_username        => 'admin',
      aem_password        => 'admin',
      file                => '/root/truststore.p12'
    }

    aem_truststore { "Delete Truststore":
      ensure       => absent,
      aem_id       => 'author',
      aem_username => 'admin',
      aem_password => 'admin'
    }

User

    aem_user { 'Create user charlie without any group':
      ensure     => present,
      name       => 'charlie',
      path       => '/home/users/c',
      password   => 'somepassword',
      permission => {
        '/libs' => ['read:false', 'modify:false', 'create:false', 'delete:false', 'acl_read:false', 'acl_edit:false', 'replicate:false'],
        '/var'  => ['read:false', 'modify:false', 'create:false', 'delete:false', 'acl_read:false', 'acl_edit:false', 'replicate:false'],
        '/tmp'  => ['read:false', 'modify:false', 'create:false', 'delete:false', 'acl_read:false', 'acl_edit:false', 'replicate:false'],
      },
    }

    aem_user { 'Create user bob and add to administrators group':
      ensure     => present,
      name       => 'bob',
      path       => '/home/users/b',
      password   => 'somepassword',
      group_name => 'administrators',
      group_path => '/home/groups/a',
    }

    aem_user { 'Add user charlie to administrators group':
      ensure     => added_to_group,
      name       => 'charlie',
      path       => '/home/users/c',
      group_name => 'administrators',
      group_path => '/home/groups/a'
    }

    aem_user { 'Change user bob password':
      ensure       => password_changed,
      name         => 'bob',
      path         => '/home/users/b',
      old_password => 'somepassword',
      new_password => 'somenewpassword'
    }

    aem_user { 'Delete user':
      ensure => absent,
      name   => 'bob',
      path   => '/home/users/b',
    }

    aem_user { 'Update replication-service user permission':
      ensure     => has_permission,
      name       => 'replication-service',
      path       => '/home/users/system/',
      permission => {
        '/etc/replication/agents.author' => ['replicate:false'],
        '/etc/replication/agents.publish' => ['replicate:false']
      }
    }

Other than single AEM resource, this module also provides predefined classes for common AEM provisioning tasks.

Remove default agents on AEM Author:

    aem_resources::author_remove_default_agents { 'Remove default author agents':
    }

Remove default agents on AEM Publish:

    aem_resources::publish_remove_default_agents { 'Remove default publish agents':
    }

Set AEM Author Primary configuration:

    aem_resources::author_primary_set_config { 'Set author primary config':
      aem_home_dir => '/opt/aem/author'
    }

Set AEM Author Standby configuration:

    aem_resources::author_standby_set_config { 'Set author standby config':
      aem_home_dir => '/opt/aem/author',
      primary_host => 'somehost',
    }

Set AEM Publish configuration:

    aem_resources::publish_set_config { 'Set Publish config':
      aem_home_dir => '/opt/aem/publish'
    }

Create system users (orchestrator, replicator, deployer, exporter, importer):

    aem_resources::create_system_users { 'Create system users':
    }

Create system users with predefined path and password:

    aem_resources::create_system_users { 'Create system users with custom passwords':
      aem_system_users => {
        deployer => {
          name     => 'deployer',
          path     => '/home/users/q',
          password => 'customdeployerpassword',
        },
        exporter => {
          name     => 'exporter',
          path     => '/home/users/e',
          password => 'customexporterpassword',
        },
        importer => {
          name     => 'importer',
          path     => '/home/users/i',
          password => 'customimporterpassword',
        },
        orchestrator => {
          name     => 'orchestrator',
          path     => '/home/users/o',
          password => 'customorchestratorpassword',
        },
        replicator => {
          name     => 'replicator',
          path     => '/home/users/r',
          password => 'customreplicatorpassword',
        }
      }
    }

Change system users password:

    aem_resources::change_system_users_password { 'Change system users password':
      aem_system_users => {
        deployer => {
          name         => 'deployer',
          path         => '/home/users/q',
          old_password => 'deployer',
          new_password => 'newdeployerpassword',
        },
        exporter => {
          name         => 'exporter',
          path         => '/home/users/e',
          old_password => 'exporter',
          new_password => 'newexporterpassword',
        },
        importer => {
          name         => 'importer',
          path         => '/home/users/i',
          old_password => 'importer',
          new_password => 'newimporterpassword',
        },
        orchestrator => {
          name         => 'orchestrator',
          path         => '/home/users/o',
          old_password => 'orchestrator',
          new_password => 'neworchestratorpassword',
        },
        replicator => {
          name         => 'replicator',
          path         => '/home/users/r',
          old_password => 'replicator',
          new_password => 'newreplicatorpassword',
        }
      }
    }

Create Puppet AEM Resources' configuration file:

    aem_resources::puppet_aem_resources_set_config { 'Set puppet-aem-resources config file for author':
      conf_dir => '/tmp/puppet-aem-resources/',
      username => 'admin',
      password => 'admin',
      protocol => 'http',
      host     => 'localhost',
      port     => 4502,
      timeout  => 300,
      debug    => false,
    }

Enable CRXDE:

    aem_resources::enable_crxde { 'Enable CRXDE':
      run_mode => 'author',
    }

Create OSGI Configuration:
  Setting the OSGI configuration in the manifest `set_osgi_config` is done by using the class `aem::osgi::config` from the puppet-module `bstopp/aem`.

    aem_resources::set_osgi_config {"Author-Primary set OSGI configuration":
      aem_home_dir   => '/opt/aem/author',
      aem_user       => 'aem-author',
      aem_user_group => 'aem-author',
      aem_id         => 'author',
      osgi_configs   => {
        'org.apache.jackrabbit.oak.plugins.segment' => {
          'org.apache.sling.installer.configuration.persist' => false,
          'name'                                             => 'Oak-Tar',
          'service.ranking'                                  => 100,
          'standby'                                          => false,
          'customBlobstore'                                  => true
        },
        'org.apache.jackrabbit.oak.plugins.segment.standby.store.StandbyStoreService' => {
          'org.apache.sling.installer.configuration.persist'                          => false,
          'mode'                                                                      => 'primary',
          'port'                                                                      => 8023,
          'secure'                                                                    => true,
          'interval'                                                                  => 5
        }
      }
    }

Multi AEM Instances
-------------------

Starting from version 2.0.0, it is possible to use Puppet AEM Resources to provision multiple AEM instances on the same machine.

Let's say you have an AEM author instance at http://localhost:4502 and an AEM publish instance at https://localhost:5433 . Set up the following configuration files:

`<puppet-config-dir>/myaemauthor.yaml`

    ---
    :username: 'admin'
    :password: 'admin'
    :protocol: 'http'
    :host: 'localhost'
    :port: 4502
    :timeout: 300
    :debug: False

`<puppet-config-dir>/myaempublish.yaml`

    ---
    :username: 'admin'
    :password: 'admin'
    :protocol: 'https'
    :host: 'localhost'
    :port: 5433
    :timeout: 300
    :debug: False

Then specify `aem_id` attribute on resource invocation in Puppet manifest:

    aem_bundle { 'Stop webdav bundle':
      ensure => stopped,
      name   => 'org.apache.sling.jcr.webdav',
      aem_id => 'myaemauthor',
    }

    aem_bundle { 'Stop webdav bundle':
      ensure => stopped,
      name   => 'org.apache.sling.jcr.webdav',
      aem_id => 'myaempublish',
    }

The above example will stop webdav bundle on both your AEM author instance and AEM publish instance.

Multi AEM Versions
------------------

Some types support multiple AEM versions due to differences how particular features are implemented between those AEM versions.

For example, AEM Author Standby configuration package was `org.apache.jackrabbit.oak.plugins.segment` in AEM <= 6.2, and it was changed to `org.apache.jackrabbit.oak.segment` in AEM >= 6.3 .

Starting version 2.1.1, `aem_version` attribute was added to the corresponding types:

    aem_resources::author_standby_set_config { 'Set author standby config':
      install_dir  => '/opt/aem/crx-quickstart/install',
      primary_host => 'somehost',
      aem_version  => '6.3',
    }

Alias
-----

Due to the need to change the state of some resources from within the same manifest, both `aem_bundle` and `aem_user` have alias resources named `aem_bundle_alias` and `aem_user_alias` .

For example, this allows you to stop and start a bundle from within the same manifest:

  aem_bundle { 'Stop webdav bundle':
    ensure => stopped,
    name   => 'org.apache.sling.jcr.webdav',
  }

  # Do other things here
  ...

  aem_bundle_alias { 'Start webdav bundle':
    ensure => started,
    name   => 'org.apache.sling.jcr.webdav',
  }

Upgrade
-------

Upgrading to 2.x.x:

* Replace all class calls to definitions.

  From:

    class { 'aem_resources::enable_crxde':
      run_mode => 'author',
    }

  To:

    aem_resources::enable_crxde { 'Enable CRXDE':
      run_mode => 'author',
    }

Testing
-------

If you run AEM on a non default port `4502`, then you need to specify the port number as environment variable:

    aem_port=45622 author_port=45622 make test-integration

The `aem_port` environment variable is used by provisioning steps that use default `aem_id`. `author_port` is used by the ones that specify `author` `aem_id`.
