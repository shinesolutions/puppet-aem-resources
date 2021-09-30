# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed
- Upgrade ruby_aem to 3.13.1

## [7.3.0] - 2021-08-31

### Added
- Add enable|disable_development_bundles class [shinesolutions/puppet-aem-curator#207]
- Add publish and release-* GitHub Actions

## [7.2.3] - 2021-03-29
### Added
- Added `force` option to `aem_saml` for enabling SAML [#101]

## [7.2.2] - 2021-03-28
### Added
- Added `force` option to `aem_ssl` for enabling SSL via Granite [#99]

## [7.2.1] - 2020-11-27
### Changed
- Upgrade puppet to 5.5.22

## [7.2.0] - 2020-09-27
### Changed
- Upgrade ruby_aem to 3.10.0
- Upgrade puppet to 5.5.21

### Fixed
- Fixed integration test

## [7.1.0] - 2020-08-06
### Changed
- Upgrade ruby_aem to 3.8.0
- Add aem_ssl type to configure SSL via Granite [shinesolutions/puppet-aem-curator#220]

## [7.0.1] - 2020-05-13
### Fixed
- Fix variable name in `author_primary_set_config`, `author_standby_set_config` & `publish_set_config`

## [7.0.0] - 2020-05-12
### Added
- Add new manifest to configure AEM Publish component `publish_set_config`

### Changed
- Refactor `author_primary_set_config` & `author_standby_set_config` manifests to use `aem::config` for setting AEM configurations

### Removed
- Removed parameter `crx_quickstart_dir` from `author_primary_set_config` & `author_standby_set_config` manifests

## [6.0.0] - 2020-05-12
### Added
- Add new puppet module `bstopp/aem`
- Add new manifest `set_osgi_config` to configure AEM OSGI nodes with the puppet module `bstopp/aem`
- Add new required parameter `aem_user, aem_user_group, aem_home_dir` to manifest `author_standby_set_config`
- Add new required parameter `aem_user, aem_user_group, aem_home_dir` to manifest `author_primary_set_config`

### Changed
- Parameter `crx_quickstart_dir` is not a required parameter for manifest `author_standby_set_config` anymore
- Parameter `crx_quickstart_dir` is not a required parameter for manifest `author_primary_set_config` anymore
- Update manifest `author_standby_set_config` to use `set_osgi_config` for setting author-standby settings
- Update manifest `author_primary_set_config` to use `set_osgi_config` for setting author-primary settings
- `SegmentNodeStoreService.config` does not get deleted anymore as part of manifest `author_primary_set_config` shinesolutions/puppet-aem-curator#200
- Enable SSL encryption for AEM Author-Standby sync [#69]

### Removed
- Removed template file `StandbyStoreService.config`
- Removed file `SegmentNodeStoreService.config`
- Fix author-standby to author-primary promotion error shinesolutions/aem-opencloud-manager#71 shinesolutions/aem-aws-stack-builder#280

## [5.6.0] - 2020-04-24
### Changed
- Refactor `aem_saml` module to use `swaqger_aem_osgi` API Client for setting SAML configuration
- Upgrade ruby_aem to 3.6.0

## [5.5.0] - 2020-04-05
### Removed
- Remove author scene7 replication agent
- Remove author screens flush agent

## [5.3.0] - 2019-12-14
### Fixed
- Fixed test fixtures for testing authentication-service keystore upload

## [5.2.0] - 2019-12-02
### Removed
- Package Deployment's consolidated health check post all packages deployment [#75]

## [5.1.0] - 2019-11-26
### Changed
- Force the changing of AEM system users' password shinesolutions/puppet-aem-curator#164
- Change Package Deployment process to check AEM health after all packages were deployed [#75]
- Update default parameters for AEM Health checks to use configurable parameters [#76]

## [5.0.0] - 2019-10-16
### Added
- Added feature to disable ssl verification for RubyAEM Client
- Enforced translation of boolean parameters in manifest deploy_packages shinesolutions/aem-aws-stack-builder#332
- Added boolean validation in manifest deploy_packages shinesolutions/aem-aws-stack-builder#332

### Changed
- Upgrade ruby_aem to 3.4.0 (first version to use swagger_aem_osgi 1.0.0)

### Fixed
- Fixed parameter passing for aem_id in `enable_saml` manifest [#71]

## [4.1.0] - 2019-07-19
### Changed
- Changed default aem_id for enabling saml
- Parameterise dispatcher farm and httpd conf template names [#65]

### Fixed
- Fixed issue with property SAML assertionConsumerServiceUrl

## [4.0.0] - 2019-06-05
### Changed
- Update aem_saml module to support swagger-aem release 3 [#63]
- Upgrade ruby_aem to 3.2.0

## [3.10.1] - 2019-05-20
### Changed
- Fix frozen literal and safe navigation Rubocop violations

## [3.10.0] - 2019-04-17
### Changed
- Modify run mode on Author Primary and Author Standby set config to handle multiple run modes
- Make package target should run pdk without Gemfile.lock in order to avoid requiring bundler

## [3.9.0] - 2019-04-01
### Changed
- Update RUNMODE replacement to always overwrite the RUNMODE with specified parameter

## [3.8.0] - 2019-02-15
### Added
- Add feature to aem_package to reinstall a existing package in the CRX Package Manager via aem_package reinstalled state

## [3.7.0] - 2019-02-13
### Added
- Add puppet_aem_resources#call_with_readiness_check for wrapping readiness check before making client call
- Add call_with_readiness_check to puppet modules before making client call

### Changed
- Package-related calls are now done after Package Manager Servlet status readiness check due to AEM 6.4 noticeable longer readiness
- Pass AEM Username & Password to check if CRX Package Manager is ready while deploying packages

## [3.6.0] - 2019-02-02
### Added
- Add new ensurable aem_package_manager_is_ready for provider aem_aem for checking if AEM Package Manager is ready shinesolutions/aem-aws-stack-builder#214
- Add feature to force the removal of the AEM Global Truststore.

### Changed
- Upgrade ruby_aem to 2.5.1

## [3.5.0] - 2019-01-08
### Added
- Add new resource manifests to archive AEM Global Truststore shinesolutions/aem-aws-stack-builder#229

### Changed
- Upgrade ruby_aem to 2.4.0

## [3.4.0] - 2018-12-17
### Added
- Add YAML syntax check to lint target
- Introducing ensure flag for installing/uninstalling packages via descriptor file shinesolutions/aem-aws-stack-builder#224
- Add temp SAML-related resource cleanup

### Changed
- Upgrade ruby_aem to 2.3.0

## [3.3.0] - 2018-11-24
### Added
- Add feature to manage AEM Truststore
- Add feature to manage AEM Authorizable Keystore
- Add feature to manage Certificates in AEM Truststore
- Add feature to manage SAML Authentication configuration

## [3.2.1] - 2018-10-18
### Changed
- Fix authentication issue in the enable_crxde manifest [#44]

## [3.2.0] - 2018-10-04
### Added
- Introduce pdk as Puppet module build

### Changed
- Fix issue with wait post Deploy package in deploy_packages.pp [#41]
- Improve readiness check after bundle start within enable CRXDE action [#42]
- Drop ruby 2.1 and 2.2 support
- Drop Puppet 4 support, add Puppet 6 support

## [3.1.1] - 2018-08-09
### Added
- Add new aem_user_alias type

## [3.1.0] - 2018-08-02
### Added
- Add feature 'absent' for module aem_path
- Add feature to define system users name & path as parameters

### Changed
- Improved credentials handling for system users

## [3.0.1] - 2018-06-24
### Changed
- Modify SSL and security config path to work with AEM 6.4

## [3.0.0] - 2018-06-23
### Changed
- Modify enable CRXDE config path to work with AEM 6.4

## [2.2.5] - 2018-04-24
### Added
- Add timeout parameter to AEM config file

## [2.2.4] - 2018-04-19
### Added
- Add packages_listed ensurable to aem_aem type

## [2.2.3] - 2018-04-04
### Added
- Add publish-dispatcher config to deny cache invalidation [#29]

## [2.2.2] - 2018-03-27
### Changed
- Fix aem_id handling for deploy packages [#27]

## [2.2.1] - 2018-03-26
### Removed
- Move puppet-aem-resources-generated httpd config to virtual_hosts_dir

## [2.2.0] - 2018-03-21
### Changed
- Rename dispatcher template variables from httpd_conf_dir to apache_conf_dir

## [2.1.1] - 2018-02-01
### Changed
- Fix AEM 6.3 Author Standby provisioning missing config file

## [2.1.0] - 2018-01-29
### Added
- Added Puppet manifest to disable crxde
- Add AEM >= 6.3 support for configuring Author Primary and Author Standby [#22]

## [2.0.2] - 2018-01-22
### Changed
- Upgrade ruby_aem to 1.4.1 with nokogiri security vulnerability fix
- Increase minimum ruby version requirement to 2.1

### Removed
- Remove port 443 listening from sample httpd.conf [#21]

## [2.0.1] - 2017-12-07
### Changed
- Fix incorrect aem_id source, was definition parameter, now package aem_id field

## [2.0.0] - 2017-10-31
### Added
- Add multi AEM instances support at manifests level by replacing classes with definitions [#19]

### Changed
- Allow custom credential at invocation level by introducing aem_username and aem_password attributes [#5]
- Change puppet-aem-resources config file mode to 644

## [1.3.0] - 2017-10-07
### Added
- Add multi AEM instances support at custom types level by introducing aem_id attribute [#19]
- Add aem resource install_status_is_finished ensurable

## [1.2.0] - 2017-09-25
### Changed
- Lock Puppet to version 4.x
- Exclude test and tools config files from module package [#16]
- Fix undefined method error when package activate is set to true [#17]
- Post package installation delay is only executed for packages that haven't been installed
- Disable timeout on package installation execution
- Replace librarian-puppet with r10k for integration test dependencies resolution

## [1.1.1] - 2017-06-02
### Changed
- Fix aem.yaml.epp template to handle non-String types

## [1.1.0] - 2017-06-01
### Added
- Add timeout configuration parameter
- Add build status readiness wait to package archive ensurable

### Changed
- Modify package archive ensurable to delete all versions of the package to be exported

## [1.0.0] - 2017-05-18
### Added
- Add support for adding parent/member group to an aem_group resource
- Add has_permission ensurable and permission param to aem_user resource [#8]

## [0.9.5] - 2017-05-10
### Added
- Add enable_crxde class
- Add all_agents_removed ensurable to aem resource [#9]

## [0.9.4] - 2017-04-19
### Added
- Add aem_health_check_is_ok ensurable to aem_aem type
- Add uninstall to destroy

### Changed
- Set author-dispatcher and publish-dispatcher config to always resolve hostname

## [0.9.3] - 2017-02-24
### Added
- Add X-Frame-Options SAMEORIGIN header to dispatcher's Apache httpd config
- Add Apache Sling GET Servlet OSGI config for DoS prevention
- Add administrative URLs blacklist to publish-dispatcher config
- Add Apache Sling Referrer Filter OSGI config for CSRF attacks prevention
- Add publish-dispatcher path and header filters for CSRF attacks prevention
- Add publish-dispatcher allowed_client config for restricting access to flush/activate content
- Add added_to_group ensurable to aem_user type
- Add group_name and group_path params to aem_user type's creation
- Add system users to administrators group
- Add retries_max_tries, retries_base_sleep_seconds, and retries_max_sleep_seconds params to aem_package type, used by package upload and package install
- Add force param to aem_user type's creation, this enforces user to be recreated if it already exists
- Add aem_outbox_replication_agent type
- Add aem_bundle_alias type
- Add class for changing system users password

### Changed
- Change deployer system user path to /home/users/q/

## [0.9.2] - 2017-02-27
### Added
- Add package archived ensurable
- Add client opts to override environment variable and config file

### Changed
- deploy_packages enforces state present
- Package download debugging no longer attempts to print response body
- Relax stdlib dependency to >= 4.14.0
- Fix aem_user change_password to create client using the details from the user whose password is to be changed

## [0.9.1] - 2017-02-13
### Added
- Add classes for removing default agents on AEM Author and Publish
- Add classes for setting AEM Author Primary and Standby configuration
- Add class for creating system users
- Add classes for setting AEM AuthorDispatcher and PublishDispatcher config
- Add class for setting Puppet AEM Resources module config
- Add AEM login readiness check retries_max_tries, retries_base_sleep_seconds, and retries_max_sleep_seconds params [#3]
- Add class for deploying multiple packages

### Changed
- Fix package not overwriting existing one when force param is set to true [#2]

## 0.9.0 - 2017-01-17
### Added
- Initial version

[#2]: https://github.com/shinesolutions/puppet-aem-resources/issues/2
[#3]: https://github.com/shinesolutions/puppet-aem-resources/issues/3
[#5]: https://github.com/shinesolutions/puppet-aem-resources/issues/5
[#8]: https://github.com/shinesolutions/puppet-aem-resources/issues/8
[#9]: https://github.com/shinesolutions/puppet-aem-resources/issues/9
[#16]: https://github.com/shinesolutions/puppet-aem-resources/issues/16
[#17]: https://github.com/shinesolutions/puppet-aem-resources/issues/17
[#19]: https://github.com/shinesolutions/puppet-aem-resources/issues/19
[#21]: https://github.com/shinesolutions/puppet-aem-resources/issues/21
[#22]: https://github.com/shinesolutions/puppet-aem-resources/issues/22
[#27]: https://github.com/shinesolutions/puppet-aem-resources/issues/27
[#29]: https://github.com/shinesolutions/puppet-aem-resources/issues/29
[#41]: https://github.com/shinesolutions/puppet-aem-resources/issues/41
[#42]: https://github.com/shinesolutions/puppet-aem-resources/issues/42
[#44]: https://github.com/shinesolutions/puppet-aem-resources/issues/44
[#63]: https://github.com/shinesolutions/puppet-aem-resources/issues/63
[#65]: https://github.com/shinesolutions/puppet-aem-resources/issues/65
[#69]: https://github.com/shinesolutions/puppet-aem-resources/issues/69
[#71]: https://github.com/shinesolutions/puppet-aem-resources/issues/71
[#75]: https://github.com/shinesolutions/puppet-aem-resources/issues/75
[#76]: https://github.com/shinesolutions/puppet-aem-resources/issues/76
[#99]: https://github.com/shinesolutions/puppet-aem-resources/issues/99
[#101]: https://github.com/shinesolutions/puppet-aem-resources/issues/101

[Unreleased]: https://github.com/shinesolutions/puppet-aem-resources/compare/7.2.3...HEAD
[7.2.3]: https://github.com/shinesolutions/puppet-aem-resources/compare/7.2.2...7.2.3
[7.2.2]: https://github.com/shinesolutions/puppet-aem-resources/compare/7.2.1...7.2.2
[7.2.1]: https://github.com/shinesolutions/puppet-aem-resources/compare/7.2.0...7.2.1
[7.2.0]: https://github.com/shinesolutions/puppet-aem-resources/compare/7.1.0...7.2.0
[7.1.0]: https://github.com/shinesolutions/puppet-aem-resources/compare/7.0.1...7.1.0
[7.0.1]: https://github.com/shinesolutions/puppet-aem-resources/compare/7.0.0...7.0.1
[7.0.0]: https://github.com/shinesolutions/puppet-aem-resources/compare/6.0.0...7.0.0
[6.0.0]: https://github.com/shinesolutions/puppet-aem-resources/compare/5.6.0...6.0.0
[5.6.0]: https://github.com/shinesolutions/puppet-aem-resources/compare/5.5.0...5.6.0
[5.5.0]: https://github.com/shinesolutions/puppet-aem-resources/compare/5.3.0...5.5.0
[5.3.0]: https://github.com/shinesolutions/puppet-aem-resources/compare/5.2.0...5.3.0
[5.2.0]: https://github.com/shinesolutions/puppet-aem-resources/compare/5.1.0...5.2.0
[5.1.0]: https://github.com/shinesolutions/puppet-aem-resources/compare/5.0.0...5.1.0
[5.0.0]: https://github.com/shinesolutions/puppet-aem-resources/compare/4.1.0...5.0.0
[4.1.0]: https://github.com/shinesolutions/puppet-aem-resources/compare/4.0.0...4.1.0
[4.0.0]: https://github.com/shinesolutions/puppet-aem-resources/compare/3.10.1...4.0.0
[3.10.1]: https://github.com/shinesolutions/puppet-aem-resources/compare/3.10.0...3.10.1
[3.10.0]: https://github.com/shinesolutions/puppet-aem-resources/compare/3.9.0...3.10.0
[3.9.0]: https://github.com/shinesolutions/puppet-aem-resources/compare/3.8.0...3.9.0
[3.8.0]: https://github.com/shinesolutions/puppet-aem-resources/compare/3.7.0...3.8.0
[3.7.0]: https://github.com/shinesolutions/puppet-aem-resources/compare/3.6.0...3.7.0
[3.6.0]: https://github.com/shinesolutions/puppet-aem-resources/compare/3.5.0...3.6.0
[3.5.0]: https://github.com/shinesolutions/puppet-aem-resources/compare/3.4.0...3.5.0
[3.4.0]: https://github.com/shinesolutions/puppet-aem-resources/compare/3.3.0...3.4.0
[3.3.0]: https://github.com/shinesolutions/puppet-aem-resources/compare/3.2.1...3.3.0
[3.2.1]: https://github.com/shinesolutions/puppet-aem-resources/compare/3.2.0...3.2.1
[3.2.0]: https://github.com/shinesolutions/puppet-aem-resources/compare/3.1.1...3.2.0
[3.1.1]: https://github.com/shinesolutions/puppet-aem-resources/compare/3.1.0...3.1.1
[3.1.0]: https://github.com/shinesolutions/puppet-aem-resources/compare/3.0.1...3.1.0
[3.0.1]: https://github.com/shinesolutions/puppet-aem-resources/compare/3.0.0...3.0.1
[3.0.0]: https://github.com/shinesolutions/puppet-aem-resources/compare/2.2.5...3.0.0
[2.2.5]: https://github.com/shinesolutions/puppet-aem-resources/compare/2.2.4...2.2.5
[2.2.4]: https://github.com/shinesolutions/puppet-aem-resources/compare/2.2.3...2.2.4
[2.2.3]: https://github.com/shinesolutions/puppet-aem-resources/compare/2.2.2...2.2.3
[2.2.2]: https://github.com/shinesolutions/puppet-aem-resources/compare/2.2.1...2.2.2
[2.2.1]: https://github.com/shinesolutions/puppet-aem-resources/compare/2.2.0...2.2.1
[2.2.0]: https://github.com/shinesolutions/puppet-aem-resources/compare/2.1.1...2.2.0
[2.1.1]: https://github.com/shinesolutions/puppet-aem-resources/compare/2.1.0...2.1.1
[2.1.0]: https://github.com/shinesolutions/puppet-aem-resources/compare/2.0.2...2.1.0
[2.0.2]: https://github.com/shinesolutions/puppet-aem-resources/compare/2.0.1...2.0.2
[2.0.1]: https://github.com/shinesolutions/puppet-aem-resources/compare/2.0.0...2.0.1
[2.0.0]: https://github.com/shinesolutions/puppet-aem-resources/compare/1.3.0...2.0.0
[1.3.0]: https://github.com/shinesolutions/puppet-aem-resources/compare/1.2.0...1.3.0
[1.2.0]: https://github.com/shinesolutions/puppet-aem-resources/compare/1.1.1...1.2.0
[1.1.1]: https://github.com/shinesolutions/puppet-aem-resources/compare/1.1.0...1.1.1
[1.1.0]: https://github.com/shinesolutions/puppet-aem-resources/compare/1.0.0...1.1.0
[1.0.0]: https://github.com/shinesolutions/puppet-aem-resources/compare/0.9.5...1.0.0
[0.9.5]: https://github.com/shinesolutions/puppet-aem-resources/compare/0.9.4...0.9.5
[0.9.4]: https://github.com/shinesolutions/puppet-aem-resources/compare/0.9.3...0.9.4
[0.9.3]: https://github.com/shinesolutions/puppet-aem-resources/compare/0.9.2...0.9.3
[0.9.2]: https://github.com/shinesolutions/puppet-aem-resources/compare/0.9.1...0.9.2
[0.9.1]: https://github.com/shinesolutions/puppet-aem-resources/compare/0.9.0...0.9.1
