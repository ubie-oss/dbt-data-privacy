setup:
	pip install --force-reinstall -r requirements/requirements-1.10.txt
	dbt deps --profiles-dir profiles --target bigquery


clean:
	rm -fr ./models/data_analysis_layer/dbt_data_privacy_data_analysis_layer


test: clean compile run-unit-tests test-integration compile

test-integration: run-integration-tests run-integration-tests-legacy

generate: clean
	bash -x scripts/generate_secured_models.sh --vars-path ./resources/vars/vars-bigquery.basic.yml --target bigquery --modern-schema

generate-legacy: clean
	bash -x scripts/generate_secured_models.sh --vars-path ./resources/vars/vars-bigquery.basic.yml --target bigquery

run-unit-tests: clean
	bash run_unit_tests.sh --target bigquery --vars-path resources/vars/vars-bigquery.basic.yml

run-integration-tests: generate
	bash run_integration_tests.sh --target bigquery --vars-path ./resources/vars/vars-bigquery.basic.yml

run-integration-tests-legacy: generate-legacy
	bash run_integration_tests_legacy.sh --target bigquery --vars-path ./resources/vars/vars-bigquery.basic.yml

test-get_tags_by_original_file_paths: clean setup
	dbt run-operation --profiles-dir ./profiles \
		--target bigquery \
		--vars "$$(cat "./resources/vars/vars-bigquery.basic.yml")" \
		--args '{"original_file_paths":["models/restricted_layer/dbt_data_privacy_restricted_layer/consents/restricted_layer__dbt_data_privacy_restricted_layer__consents.sql"]}' \
		get_tags_by_original_file_paths

compile: clean setup
	dbt compile --profiles-dir ./profiles \
		--target bigquery \
		--vars "$$(cat "./resources/vars/vars-bigquery.basic.yml")"
