ci: tools deps clean lint validate

deps:
	echo "TODO"

clean:
	echo "TODO"

lint:
	puppet-lint \
		--fail-on-warnings \
		--no-140chars-check \
		--no-autoloader_layout-check \
		--no-documentation-check \
		--no-only_variable_string-check \
		--no-selector_inside_resource-check \
		test/integration/*.pp

tools:
	gem install puppet puppet-lint

.PHONY: ci clean deps lint tools
