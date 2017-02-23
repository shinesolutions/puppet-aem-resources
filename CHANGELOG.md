### 0.9.2
* deploy_packages enforces state present
* Package download debugging no longer attempts to print response body
* Add package archived ensurable
* Relax stdlib dependency to >= 4.14.0
* Add client opts to override environment variable and config file

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
