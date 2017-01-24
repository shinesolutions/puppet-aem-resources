ci: tools deps clean lint

deps:
	gem install bundler
	rm -rf .bundle
	bundle install

clean:
	rm -rf pkg
	rm -rf test/integration/modules/

lint:
	puppet-lint \
		--fail-on-warnings \
		--no-140chars-check \
		--no-autoloader_layout-check \
		--no-documentation-check \
		--no-only_variable_string-check \
		--no-selector_inside_resource-check \
		test/integration/*

test-integration:
	mkdir -p test/integration/modules/aem_resources/
	cp -R lib test/integration/modules/aem_resources/
	cp -R manifests test/integration/modules/aem_resources/
	cp test/fixtures/somepackage-1.2.3.zip /tmp/
	for test in aem_aem_get_login_page_wait_until_ready aem_bundle_stopped aem_bundle_started aem_flush_agent_present aem_flush_agent_absent aem_group_present aem_group_absent aem_package_present aem_package_absent aem_replication_agent_present aem_replication_agent_absent aem_repository aem_user_present aem_user_password_changed aem_user_absent aem_path_activate aem_node_present aem_config_property_present aem_node_absent ; do \
    puppet apply --modulepath=test/integration/modules/ test/integration/$$test.pp; \
  done
	for test in aem_author_remove_default_agents aem_publish_remove_default_agents ; do \
    puppet apply --modulepath=test/integration/modules/ test/integration/$$test.pp; \
  done

build:
	puppet module build .

tools:
	gem install puppet puppet-lint

.PHONY: ci clean deps lint test-integration build tools
