ci: clean deps test acceptance package

deps:
	gem install bundler --version=4.0.22
	bundle install

# Also removes the files the scenarios create, as the previous clean target did
clean:
	rm -rf bin/ pkg/ stage/ vendor/ modules/
	rm -rf /tmp/shinesolutions/puppet-aem-resources/

# lint, validate (syntax, metadata_lint), unit specs and static checks.
# safe.directory lets the git-based checks run as root in the buildenv container
test:
	GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0=safe.directory GIT_CONFIG_VALUE_0=$(CURDIR) \
		bundle exec rake test

# yamllint also covers .fixtures.yml and the acceptance nodesets, which the reference module doesn't have
lint:
	bundle exec rake lint syntax metadata_lint rubocop
	yamllint .markdownlint.yaml .fixtures.yml .github/workflows/*.yaml spec/acceptance/nodesets/*.yml
	markdownlint-cli2 README.md
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
	bundle exec rake spec_prep
	# set up test fixtures
	useradd aem || echo "User might already exist"
	mkdir -p /tmp/shinesolutions/puppet-aem-resources/author/somepackagegroup/somepackage/1.2.3/
	cp spec/acceptance/fixtures/* /tmp/shinesolutions/puppet-aem-resources/
	cp spec/acceptance/fixtures/somepackage-1.2.3.zip /tmp/shinesolutions/puppet-aem-resources/author/somepackagegroup/
	mkdir -p /tmp/shinesolutions/puppet-aem-resources/author-primary-6.2/crx-quickstart/
	mkdir -p /tmp/shinesolutions/puppet-aem-resources/author-primary-6.2/crx-quickstart/bin/
	mkdir -p /tmp/shinesolutions/puppet-aem-resources/author-primary-6.2/crx-quickstart/install/
	cp spec/acceptance/fixtures/start-env /tmp/shinesolutions/puppet-aem-resources/author-primary-6.2/crx-quickstart/bin/
	cp spec/acceptance/fixtures/start /tmp/shinesolutions/puppet-aem-resources/author-primary-6.2/crx-quickstart/bin/
	mkdir -p /tmp/shinesolutions/puppet-aem-resources/author-primary-6.3/crx-quickstart/
	mkdir -p /tmp/shinesolutions/puppet-aem-resources/author-primary-6.3/crx-quickstart/bin/
	mkdir -p /tmp/shinesolutions/puppet-aem-resources/author-primary-6.3/crx-quickstart/install/
	cp spec/acceptance/fixtures/start-env /tmp/shinesolutions/puppet-aem-resources/author-primary-6.3/crx-quickstart/bin/
	cp spec/acceptance/fixtures/start /tmp/shinesolutions/puppet-aem-resources/author-primary-6.3/crx-quickstart/bin/
	mkdir -p /tmp/shinesolutions/puppet-aem-resources/author-standby-6.2/crx-quickstart/
	mkdir -p /tmp/shinesolutions/puppet-aem-resources/author-standby-6.2/crx-quickstart/bin/
	mkdir -p /tmp/shinesolutions/puppet-aem-resources/author-standby-6.2/crx-quickstart/install/
	cp spec/acceptance/fixtures/start-env /tmp/shinesolutions/puppet-aem-resources/author-standby-6.2/crx-quickstart/bin/
	cp spec/acceptance/fixtures/start /tmp/shinesolutions/puppet-aem-resources/author-standby-6.2/crx-quickstart/bin/
	mkdir -p /tmp/shinesolutions/puppet-aem-resources/author-standby-6.3/crx-quickstart/
	mkdir -p /tmp/shinesolutions/puppet-aem-resources/author-standby-6.3/crx-quickstart/bin/
	mkdir -p /tmp/shinesolutions/puppet-aem-resources/author-standby-6.3/crx-quickstart/install/
	cp spec/acceptance/fixtures/start-env /tmp/shinesolutions/puppet-aem-resources/author-standby-6.3/crx-quickstart/bin/
	cp spec/acceptance/fixtures/start /tmp/shinesolutions/puppet-aem-resources/author-standby-6.3/crx-quickstart/bin/
	mkdir -p /tmp/shinesolutions/puppet-aem-resources/publish/crx-quickstart/
	mkdir -p /tmp/shinesolutions/puppet-aem-resources/publish/crx-quickstart/bin/
	mkdir -p /tmp/shinesolutions/puppet-aem-resources/publish/crx-quickstart/install/
	cp spec/acceptance/fixtures/start-env /tmp/shinesolutions/puppet-aem-resources/publish/crx-quickstart/bin/
	cp spec/acceptance/fixtures/start /tmp/shinesolutions/puppet-aem-resources/publish/crx-quickstart/bin/
	cp spec/acceptance/fixtures/cert_ssl.crt /tmp/shinesolutions/puppet-aem-resources/
	cp spec/acceptance/fixtures/cert_ssl.der /tmp/shinesolutions/puppet-aem-resources/
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

# Move the Unreleased CHANGELOG.md entries to a release section, e.g. make changelog VERSION=7.11.1
# (VERSION defaults to metadata.json's version without its pre-release suffix)
changelog:
	bundle exec rake "changelog:release[$(VERSION)]"

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

.PHONY: ci deps clean test lint acceptance test-integration test-fixtures docs changelog package release publish-check publish
