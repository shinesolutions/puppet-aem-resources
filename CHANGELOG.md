### 2.2.1
* Move puppet-aem-resources-generated httpd config to virtual_hosts_dir

### 2.2.0
* Rename dispatcher template variables from httpd_conf_dir to apache_conf_dir

### 2.1.1
* Fix AEM 6.3 Author Standby provisioning missing config file

### 2.1.0
* Added Puppet manifest to disable crxde
* Add AEM >= 6.3 support for configuring Author Primary and Author Standby #22

### 2.0.2
* Remove port 443 listening from sample httpd.conf #21
* Upgrade ruby_aem to 1.4.1 with nokogiri security vulnerability fix
* Increase minimum ruby version requirement to 2.1

### 2.0.1
* Fix incorrect aem_id source, was definition parameter, now package aem_id field

### 2.0.0
* Add multi AEM instances support at manifests level by replacing classes with definitions #19
* Allow custom credential at invocation level by introducing aem_username and aem_password attributes #5
* Change puppet-aem-resources config file mode to 644

### 1.3.0
* Add multi AEM instances support at custom types level by introducing aem_id attribute #19
* Add aem resource install_status_is_finished ensurable

### 1.2.0
* Lock Puppet to version 4.x
* Exclude test and tools config files from module package #16
* Fix undefined method error when package activate is set to true #17
* Post package installation delay is only executed for packages that haven't been installed
* Disable timeout on package installation execution
* Replace librarian-puppet with r10k for integration test dependencies resolution

### 1.1.1
* Fix aem.yaml.epp template to handle non-String types

### 1.1.0
* Add timeout configuration parameter
* Modify package archive ensurable to delete all versions of the package to be exported
* Add build status readiness wait to package archive ensurable

### 1.0.0
* Add support for adding parent/member group to an aem_group resource
* Add has_permission ensurable and permission param to aem_user resource #8

### 0.9.5
* Add enable_crxde class
* Add all_agents_removed ensurable to aem resource #9

### 0.9.4
* Set author-dispatcher and publish-dispatcher config to always resolve hostname
* Add aem_health_check_is_ok ensurable to aem_aem type
* Add uninstall to destroy

### 0.9.3
* Add X-Frame-Options SAMEORIGIN header to dispatcher's Apache httpd config
* Add Apache Sling GET Servlet OSGI config for DoS prevention
* Add administrative URLs blacklist to publish-dispatcher config
* Add Apache Sling Referrer Filter OSGI config for CSRF attacks prevention
* Add publish-dispatcher path and header filters for CSRF attacks prevention
* Add publish-dispatcher allowed_client config for restricting access to flush/activate content
* Add added_to_group ensurable to aem_user type
* Add group_name and group_path params to aem_user type's creation
* Add system users to administrators group
* Add retries_max_tries, retries_base_sleep_seconds, and retries_max_sleep_seconds params to aem_package type, used by package upload and package install
* Add force param to aem_user type's creation, this enforces user to be recreated if it already exists
* Add aem_outbox_replication_agent type
* Add aem_bundle_alias type
* Change deployer system user path to /home/users/q/
* Add class for changing system users password

### 0.9.2
* deploy_packages enforces state present
* Package download debugging no longer attempts to print response body
* Add package archived ensurable
* Relax stdlib dependency to >= 4.14.0
* Add client opts to override environment variable and config file
* Fix aem_user change_password to create client using the details from the user whose password is to be changed

### 0.9.1
* Add classes for removing default agents on AEM Author and Publish
* Add classes for setting AEM Author Primary and Standby configuration
* Add class for creating system users
* Add classes for setting AEM AuthorDispatcher and PublishDispatcher config
* Add class for setting Puppet AEM Resources module config
* Add AEM login readiness check retries_max_tries, retries_base_sleep_seconds, and retries_max_sleep_seconds params #3
* Fix package not overwriting existing one when force param is set to true #2
* Add class for deploying multiple packages

### 0.9.0
* Initial version
