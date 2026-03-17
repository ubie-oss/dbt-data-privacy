.PHONY: setup clean test test-integration generate run-unit-tests run-integration-tests run-integration-tests-legacy compile \
	run-unit-tests-core run-unit-tests-fusion run-integration-tests-core run-integration-tests-fusion \
	generate-core generate-fusion

setup:
	uv sync
	uv run dbt deps --profiles-dir profiles --target bigquery

clean:
	rm -fr ./models/data_analysis_layer/dbt_data_privacy_data_analysis_layer
	rm -fr ./target ./logs ./dbt_packages

test: clean
	uv run nox -s dev_unit_tests

run-unit-tests: clean
	uv run nox -s dev_unit_tests

run-unit-tests-core: clean
	uv run nox -s "unit_tests-3.12(uv_group='dbt-core-1-11')"

run-unit-tests-fusion: clean
	uv run nox -s "unit_tests-3.12(uv_group='dbt-fusion')"

test-integration: clean
	uv run nox -s dev_integration_tests

run-integration-tests: clean
	uv run nox -s dev_integration_tests

run-integration-tests-core: clean
	uv run nox -s "integration_tests-3.12(uv_group='dbt-core-1-11')"

run-integration-tests-fusion: clean
	uv run nox -s "integration_tests-3.12(uv_group='dbt-fusion')"

generate-core: clean
	uv run nox -s "generate_models-3.12(uv_group='dbt-core-1-11')"

generate-fusion: clean
	uv run nox -s "generate_models-3.12(uv_group='dbt-fusion')"

generate: generate-core

compile: clean setup
	uv run dbt compile --profiles-dir ./profiles \
		--target bigquery \
		--vars "$$(cat "./resources/vars/vars-bigquery.basic.json")"
