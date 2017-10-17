ci: tools clean deps lint

deps:
	gem install bundler
	rm -rf .bundle
	bundle install
	cd test/integration/ && r10k puppetfile install --moduledir modules

clean:
	rm -rf pkg
	rm -rf test/integration/.tmp/
	rm -rf test/integration/modules/
	rm -rf /tmp/shinesolutions/puppet-aem-resources/

lint:
	puppet-lint \
		--fail-on-warnings \
		--no-140chars-check \
		--no-autoloader_layout-check \
		--no-documentation-check \
		test/integration/*/*.pp \
		manifests/*.pp
	rubocop

test-integration:
	# set up module
	mkdir -p test/integration/modules/aem_resources/
	cp -R files test/integration/modules/aem_resources/
	cp -R lib test/integration/modules/aem_resources/
	cp -R manifests test/integration/modules/aem_resources/
	cp -R templates test/integration/modules/aem_resources/
	# set up test fixtures
	mkdir -p /tmp/shinesolutions/puppet-aem-resources/somepackagegroup/somepackage/1.2.3/
	cp test/fixtures/* /tmp/shinesolutions/puppet-aem-resources/
	cp test/fixtures/somepackage-1.2.3.zip /tmp/shinesolutions/puppet-aem-resources/somepackagegroup/
	mkdir -p /tmp/shinesolutions/puppet-aem-resources/author-primary/bin/
	cp test/fixtures/start-env /tmp/shinesolutions/puppet-aem-resources/author-primary/bin/
	mkdir -p /tmp/shinesolutions/puppet-aem-resources/author-standby/bin/
	cp test/fixtures/start-env /tmp/shinesolutions/puppet-aem-resources/author-standby/bin/
	# # test manifests
	# for test in test/integration/manifests/*.pp; do \
	#   puppet apply --modulepath=test/integration/modules/ $$test; \
	# done
	# # test resources
	# for test in test/integration/resources/*.pp; do \
	#   puppet apply --modulepath=test/integration/modules/ $$test; \
	# done
	puppet apply --debug --modulepath=test/integration/modules/ test/integration/manifests/21_change_system_users_password.pp; \

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
	puppet module build .

tools:
	gem install puppet puppet-lint r10k

.PHONY: ci clean deps lint test-integration package tools
