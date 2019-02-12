# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Add puppet_aem_resources#call_with_readiness_check for wrapping readiness check before making client call

### Changed
- Package-related calls are now done after Package Manager Servlet status readiness check due to AEM 6.4 noticeable longer readiness

## [3.6.0] - 2019-02-02

### Added
- Add new ensurable aem_package_manager_is_ready for provider aem_aem for checking if AEM Package Manager is ready shinesolutions/aem-aws-stack-builder#214

### Changed
- Upgrade ruby_aem to 2.5.1

### Added
- Add feature to force the removal of the AEM Global Truststore.

## [3.5.0] - 2019-01-08

### Added

- Add new resource manifests to archive AEM Global Truststore shinesolutions/aem-aws-stack-builder#229

### Changed
- Upgrade ruby_aem to 2.4.0

### Removed

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
- Fix authentication issue in the enable_crxde manifest #44

## [3.2.0] - 2018-10-04

### Added
- Introduce pdk as Puppet module build

### Changed
- Fix issue with wait post Deploy package in deploy_packages.pp #41
- Improve readiness check after bundle start within enable CRXDE action #42
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
- Add publish-dispatcher config to deny cache invalidation #29

## [2.2.2] - 2018-03-27

### Changed
- Fix aem_id handling for deploy packages #27

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
- Add AEM >= 6.3 support for configuring Author Primary and Author Standby #22

## [2.0.2] - 2018-01-22

### Changed
- Upgrade ruby_aem to 1.4.1 with nokogiri security vulnerability fix
- Increase minimum ruby version requirement to 2.1

### Removed
- Remove port 443 listening from sample httpd.conf #21

## [2.0.1] - 2017-12-07

### Changed
- Fix incorrect aem_id source, was definition parameter, now package aem_id field

## [2.0.0] - 2017-10-31

### Added
- Add multi AEM instances support at manifests level by replacing classes with definitions #19

### Changed
- Allow custom credential at invocation level by introducing aem_username and aem_password attributes #5
- Change puppet-aem-resources config file mode to 644

## [1.3.0] - 2017-10-07

### Added
- Add multi AEM instances support at custom types level by introducing aem_id attribute #19
- Add aem resource install_status_is_finished ensurable

## [1.2.0] - 2017-09-25

### Changed
- Lock Puppet to version 4.x
- Exclude test and tools config files from module package #16
- Fix undefined method error when package activate is set to true #17
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
- Add has_permission ensurable and permission param to aem_user resource #8

## [0.9.5] - 2017-05-10

### Added
- Add enable_crxde class
- Add all_agents_removed ensurable to aem resource #9

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
- Add AEM login readiness check retries_max_tries, retries_base_sleep_seconds, and retries_max_sleep_seconds params #3
- Add class for deploying multiple packages

### Changed
- Fix package not overwriting existing one when force param is set to true #2

## [0.9.0] - 2017-01-17

### Added
- Initial version
