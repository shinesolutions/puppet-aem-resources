# Where the spec/acceptance scenarios read and write their files (TEST_DIR in spec/spec_helper_acceptance.rb)
TEST_DIR := /tmp/shinesolutions/puppet-aem-resources

# Cheapest checks first: lint-extra (seconds), test (lint, validate, unit specs), acceptance (minutes), package
ci: clean deps lint-extra test acceptance package

deps:
	gem install bundler --version=4.0.22
	bundle install

# Also removes the files the scenarios create, as the previous clean target did
clean:
	rm -rf bin/ pkg/ stage/ vendor/
	rm -rf $(TEST_DIR)/

# lint, validate (syntax, metadata_lint), unit specs and static checks.
# safe.directory lets the git-based checks run as root in the buildenv container
test:
	GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0=safe.directory GIT_CONFIG_VALUE_0=$(CURDIR) \
		bundle exec rake test

# All static checks, without the unit specs
lint: lint-extra
	bundle exec rake lint syntax metadata_lint

# The static checks rake test doesn't run (its check task skips misplaced_files and utf8),
# so ci runs them without repeating rake test's lint/syntax/metadata_lint.
# yamllint and markdownlint cover every hand-written YAML and Markdown file (not the generated docs/),
# except CHANGELOG.md, which rtk release rewrites in its own layout
lint-extra:
	bundle exec rake rubocop check:misplaced_files check:utf8
	yamllint .fixtures.yml .markdownlint.yaml .rubocop.yml .github/workflows/*.yaml spec/default_facts.yml spec/acceptance/nodesets/*.yml
	markdownlint-cli2 README.md .github/ISSUE_TEMPLATE/*.md
	python3 -m json.tool .rtk.json

# Run acceptance tests against every nodeset; beaker only runs one per invocation.
# BEAKER_PUPPET_COLLECTION=openvox9 because the module requires OpenVox 9 (beaker defaults to openvox8)
acceptance:
	set -e; for nodeset in spec/acceptance/nodesets/*.yml; do \
		echo "== $$nodeset"; \
		BEAKER_PUPPET_COLLECTION=openvox9 BEAKER_SETFILE=$$nodeset bundle exec rake beaker; \
	done

# Apply every spec/acceptance scenario on a host running AEM, set aem_port to its port
test-integration:
	# set up the module and its dependencies in spec/fixtures/modules
	bundle exec rake fixtures:prep
	# set up test fixtures
	useradd aem || echo "User might already exist"
	mkdir -p $(TEST_DIR)/author/somepackagegroup/somepackage/1.2.3/
	cp spec/acceptance/fixtures/* $(TEST_DIR)/
	cp spec/acceptance/fixtures/somepackage-1.2.3.zip $(TEST_DIR)/author/somepackagegroup/
	mkdir -p $(TEST_DIR)/author-primary-6.2/crx-quickstart/
	mkdir -p $(TEST_DIR)/author-primary-6.2/crx-quickstart/bin/
	mkdir -p $(TEST_DIR)/author-primary-6.2/crx-quickstart/install/
	cp spec/acceptance/fixtures/start-env $(TEST_DIR)/author-primary-6.2/crx-quickstart/bin/
	cp spec/acceptance/fixtures/start $(TEST_DIR)/author-primary-6.2/crx-quickstart/bin/
	mkdir -p $(TEST_DIR)/author-primary-6.3/crx-quickstart/
	mkdir -p $(TEST_DIR)/author-primary-6.3/crx-quickstart/bin/
	mkdir -p $(TEST_DIR)/author-primary-6.3/crx-quickstart/install/
	cp spec/acceptance/fixtures/start-env $(TEST_DIR)/author-primary-6.3/crx-quickstart/bin/
	cp spec/acceptance/fixtures/start $(TEST_DIR)/author-primary-6.3/crx-quickstart/bin/
	mkdir -p $(TEST_DIR)/author-standby-6.2/crx-quickstart/
	mkdir -p $(TEST_DIR)/author-standby-6.2/crx-quickstart/bin/
	mkdir -p $(TEST_DIR)/author-standby-6.2/crx-quickstart/install/
	cp spec/acceptance/fixtures/start-env $(TEST_DIR)/author-standby-6.2/crx-quickstart/bin/
	cp spec/acceptance/fixtures/start $(TEST_DIR)/author-standby-6.2/crx-quickstart/bin/
	mkdir -p $(TEST_DIR)/author-standby-6.3/crx-quickstart/
	mkdir -p $(TEST_DIR)/author-standby-6.3/crx-quickstart/bin/
	mkdir -p $(TEST_DIR)/author-standby-6.3/crx-quickstart/install/
	cp spec/acceptance/fixtures/start-env $(TEST_DIR)/author-standby-6.3/crx-quickstart/bin/
	cp spec/acceptance/fixtures/start $(TEST_DIR)/author-standby-6.3/crx-quickstart/bin/
	mkdir -p $(TEST_DIR)/publish/crx-quickstart/
	mkdir -p $(TEST_DIR)/publish/crx-quickstart/bin/
	mkdir -p $(TEST_DIR)/publish/crx-quickstart/install/
	cp spec/acceptance/fixtures/start-env $(TEST_DIR)/publish/crx-quickstart/bin/
	cp spec/acceptance/fixtures/start $(TEST_DIR)/publish/crx-quickstart/bin/
	cp spec/acceptance/fixtures/cert_ssl.crt $(TEST_DIR)/
	cp spec/acceptance/fixtures/cert_ssl.der $(TEST_DIR)/
	# test manifests
	# author_port needs to be set here for spec/acceptance/manifests/30_deploy_pakages.pp scenario
	for test in spec/acceptance/manifests/*.pp; do \
	  author_port=$$aem_port bundle exec puppet apply --modulepath=spec/fixtures/modules/ $$test; \
	done
	# test resources
	# author_port needs to be set here for spec/acceptance/resources/10_aem_bundle_stopped.pp scenario
	for test in spec/acceptance/resources/*.pp; do \
	  author_port=$$aem_port bundle exec puppet apply --modulepath=spec/fixtures/modules/ $$test; \
	done

# Regenerate the scenarios' aem.key/aem.cert (kept from the previous Makefile)
test-fixtures:
	rm -f spec/acceptance/fixtures/aem.key spec/acceptance/fixtures/aem.cert
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
		-keyout spec/acceptance/fixtures/aem.key \
		-out spec/acceptance/fixtures/aem.cert

# Regenerate the HTML reference in docs/ (published on GitHub Pages)
docs:
	bundle exec rake "strings:generate[,,,,,,--output-dir docs]"

package: deps
	bundle exec rake module:build

release:
	rtk release

# Check the module is ready to publish to the Puppet Forge; reports what is missing.
# safe.directory lets the git-based checks run as root in the buildenv container
publish-check: package
	GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0=safe.directory GIT_CONFIG_VALUE_0=$(CURDIR) \
		tools/publish-check

# Publish the built package to the Puppet Forge, run by the publish workflow on a pushed tag.
# Requires BLACKSMITH_FORGE_API_KEY (a Forge API key) and a passing publish-check
publish: publish-check
	bundle exec rake module:push

.PHONY: ci deps clean test lint lint-extra acceptance test-integration test-fixtures docs package release publish-check publish
