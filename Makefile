ci: clean deps lint package

deps:
	gem install bundler
	bundle install --binstubs
	cd test/integration/ && bundle exec r10k puppetfile install --verbose --moduledir modules

clean:
	rm -rf bin/ pkg/ stage/ vendor/
	rm -rf test/integration/.tmp/ \
	  test/integration/modules/ \
	  /tmp/shinesolutions/puppet-aem-resources/

lint:
	bundle exec puppet-lint \
		--fail-on-warnings \
		--no-140chars-check \
		--no-autoloader_layout-check \
		--no-documentation-check \
		test/integration/*/*.pp \
		manifests/*.pp
	puppet epp validate templates/*.epp
	bundle exec rubocop --config .rubocop.yml lib/ Gemfile
	pdk validate metadata

test-integration:
	# set up module
	mkdir -p test/integration/modules/aem_resources/
	cp -R files test/integration/modules/aem_resources/
	cp -R lib test/integration/modules/aem_resources/
	cp -R manifests test/integration/modules/aem_resources/
	cp -R templates test/integration/modules/aem_resources/
	# set up test fixtures
	mkdir -p /tmp/shinesolutions/puppet-aem-resources/author/somepackagegroup/somepackage/1.2.3/
	cp test/fixtures/* /tmp/shinesolutions/puppet-aem-resources/
	cp test/fixtures/somepackage-1.2.3.zip /tmp/shinesolutions/puppet-aem-resources/author/somepackagegroup/
	mkdir -p /tmp/shinesolutions/puppet-aem-resources/author-primary-6.2/bin/
	cp test/fixtures/start-env /tmp/shinesolutions/puppet-aem-resources/author-primary-6.2/bin/
	mkdir -p /tmp/shinesolutions/puppet-aem-resources/author-primary-6.3/bin/
	cp test/fixtures/start-env /tmp/shinesolutions/puppet-aem-resources/author-primary-6.3/bin/
	mkdir -p /tmp/shinesolutions/puppet-aem-resources/author-standby-6.2/bin/
	cp test/fixtures/start-env /tmp/shinesolutions/puppet-aem-resources/author-standby-6.2/bin/
	mkdir -p /tmp/shinesolutions/puppet-aem-resources/author-standby-6.3/bin/
	cp test/fixtures/start-env /tmp/shinesolutions/puppet-aem-resources/author-standby-6.3/bin/
	# test manifests
	for test in test/integration/manifests/*.pp; do \
	  puppet apply --modulepath=test/integration/modules/ $$test; \
	done
	# test resources
	for test in test/integration/resources/*.pp; do \
	  puppet apply --modulepath=test/integration/modules/ $$test; \
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

package:
	pdk build --force

.PHONY: ci clean deps lint test-integration package
