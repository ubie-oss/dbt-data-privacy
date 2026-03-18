lint:
	pre-commit run -a

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

generate-models-legacy:
	$(MAKE) -C integration_tests generate-legacy

run-integration-tests:
	$(MAKE) -C integration_tests run-integration-tests

run-integration-tests-legacy:
	$(MAKE) -C integration_tests run-integration-tests-legacy

test-integration:
	$(MAKE) -C integration_tests test-integration

test: run-unit-tests test-integration
