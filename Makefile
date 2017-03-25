ci: tools deps clean lint

deps:
	gem install bundler
	rm -rf .bundle
	bundle install
	cd test/integration/ && librarian-puppet install --path modules --verbose

clean:
	rm -rf pkg
	rm -rf test/integration/.librarian/
	rm -rf test/integration/.tmp/
	rm -rf test/integration/modules/
	rm -rf /tmp/shinesolutions/puppet-aem-resources/

lint:
	puppet-lint \
		--fail-on-warnings \
		--no-140chars-check \
		--no-autoloader_layout-check \
		--no-documentation-check \
		--no-only_variable_string-check \
		--no-selector_inside_resource-check \
		test/integration/*.pp \
		manifests/*.pp

test-integration:
	mkdir -p test/integration/modules/aem_resources/
	mkdir -p /tmp/shinesolutions/puppet-aem-resources/somepackagegroup/somepackage/1.2.3/
	cp -R files test/integration/modules/aem_resources/
	cp -R lib test/integration/modules/aem_resources/
	cp -R manifests test/integration/modules/aem_resources/
	cp -R templates test/integration/modules/aem_resources/
	cp test/fixtures/* /tmp/shinesolutions/puppet-aem-resources/
	cp test/fixtures/somepackage-1.2.3.zip /tmp/shinesolutions/puppet-aem-resources/somepackagegroup/
	mkdir -p /tmp/shinesolutions/puppet-aem-resources/author-primary/bin/
	cp test/fixtures/start-env /tmp/shinesolutions/puppet-aem-resources/author-primary/bin/
	mkdir -p /tmp/shinesolutions/puppet-aem-resources/author-standby/bin/
	cp test/fixtures/start-env /tmp/shinesolutions/puppet-aem-resources/author-standby/bin/
	for test in aem_author_remove_default_agents aem_publish_remove_default_agents aem_author_primary_set_config aem_author_standby_set_config aem_author_set_osgi_config aem_create_system_users aem_create_system_users_forced aem_author_dispatcher_set_config aem_publish_set_osgi_config aem_publish_dispatcher_set_config aem_deploy_packages aem_author_publish_enable_ssl aem_puppet_aem_resources_set_config; do \
    puppet apply --modulepath=test/integration/modules/ test/integration/$$test.pp; \
  done
	for test in aem_aem_get_login_page_wait_until_ready aem_bundle_stopped aem_bundle_started aem_flush_agent_present aem_flush_agent_absent aem_group_present aem_group_absent aem_package_archived aem_package_present aem_package_absent aem_replication_agent_present aem_replication_agent_absent aem_outbox_replication_agent_present aem_outbox_replication_agent_absent aem_repository aem_user_present aem_user_password_changed aem_user_added_to_group aem_user_absent aem_path_activate aem_node_present aem_config_property_present aem_node_absent ; do \
    puppet apply --modulepath=test/integration/modules/ test/integration/$$test.pp; \
  done

test-fixtures:
	rm -f test/fixtures/aem.key test/fixtures/aem.cert
	# use 'somekeystorepassword' when prompted
	# this is due to java_ks using the same password for
	# both keystore and the key inside the keystore
	# so for integration testing, we're passing the same
	# password
	openssl req \
		-new \
		-newkey rsa:4096 \
		-days 365 \
		-x509 \
		-subj "/C=AU/ST=Victoria/L=Melbourne/O=Sample Organisation/CN=aem.cert" \
		-keyout test/fixtures/aem.key \
		-out test/fixtures/aem.cert

build:
	puppet module build .

tools:
	gem install puppet puppet-lint librarian-puppet

.PHONY: ci clean deps lint test-integration build tools
