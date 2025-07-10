lint: lint-yaml lint-bash

lint-yaml:
	bash ./ci/lint_yaml.sh

lint-bash:
	bash ./ci/lint_bash.sh

generate-toc:
	markdown-toc --maxdepth 5 -i README.md

######################################################################
# Integration Tests
######################################################################
setup-integration-tests:
	$(MAKE) -C integration_tests setup

run-unit-tests:
	$(MAKE) -C integration_tests run-unit-tests

generate-models:
	$(MAKE) -C integration_tests generate

run-integration-tests:
	$(MAKE) -C integration_tests run-integration-tests

run-integration-tests-legacy:
	$(MAKE) -C integration_tests run-integration-tests-legacy

test-integration:
	$(MAKE) -C integration_tests test-integration

test: run-unit-tests test-integration
