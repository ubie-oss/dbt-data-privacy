.PHONY: setup clean test test-integration generate generate-legacy run-unit-tests run-integration-tests run-integration-tests-legacy compile

setup:
	uv sync
	uv run dbt deps --profiles-dir profiles --target bigquery

clean:
	rm -fr ./models/data_analysis_layer/dbt_data_privacy_data_analysis_layer
	rm -fr ./models/data_analysis_layer/dbt_data_privacy_data_analysis_layer_legacy
	rm -fr ./target ./logs ./dbt_packages

test: clean
	uv run nox -s dev_unit_tests

run-unit-tests: clean
	uv run nox -s dev_unit_tests

test-integration: clean
	uv run nox -s dev_integration_tests

run-integration-tests: clean
	uv run nox -s dev_integration_tests

generate: clean
	bash -x scripts/generate_secured_models.sh --vars-path ./resources/vars/vars-bigquery.basic.yml --target bigquery --modern-schema

generate-legacy: clean
	bash -x scripts/generate_secured_models.sh --vars-path ./resources/vars/vars-bigquery.basic.yml --target bigquery

compile: clean setup
	uv run dbt compile --profiles-dir ./profiles \
		--target bigquery \
		--vars "$$(cat "./resources/vars/vars-bigquery.basic.yml")"
