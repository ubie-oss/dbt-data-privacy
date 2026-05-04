.PHONY: setup clean test test-integration generate run-unit-tests run-integration-tests run-integration-tests-legacy compile \
	run-unit-tests-core run-unit-tests-fusion run-integration-tests-core run-integration-tests-fusion \
	generate-core generate-fusion

setup:
	uv sync
	uv run dbt deps --profiles-dir profiles --target bigquery

clean:
	rm -fr ./models/data_analysis_layer/dbt_data_privacy_data_analysis_layer
	rm -fr ./target ./logs ./dbt_packages

test: run-unit-tests run-integration-tests

run-unit-tests: run-unit-tests-core run-unit-tests-fusion

# Unset NO_COLOR so nox is not passed both --no-color and --force-color (e.g. in CI).
run-unit-tests-core: clean
	env -u NO_COLOR uv run nox -s "unit_tests-3.12(uv_group='dbt-core-1-11')"

run-unit-tests-fusion: clean
	env -u NO_COLOR uv run nox -s "unit_tests-3.12(uv_group='dbt-fusion')"

run-integration-tests: run-integration-tests-core run-integration-tests-fusion

run-integration-tests-core: clean
	env -u NO_COLOR uv run nox -s "integration_tests-3.12(uv_group='dbt-core-1-11')"

run-integration-tests-fusion: clean
	env -u NO_COLOR uv run nox -s "integration_tests-3.12(uv_group='dbt-fusion')"

generate: generate-core generate-fusion

generate-core: clean
	env -u NO_COLOR uv run nox -s "generate_models-3.12(uv_group='dbt-core-1-11')"

generate-fusion: clean
	env -u NO_COLOR uv run nox -s "generate_models-3.12(uv_group='dbt-fusion')"

compile: clean setup
	uv run dbt compile --profiles-dir ./profiles \
		--target bigquery \
		--vars "$$(cat "./resources/vars/vars-bigquery.basic.json")"
