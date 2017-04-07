### 0.9.4
*

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
