setup:
	pip install -r requirements/requirements-1.4.txt
	dbt deps --profiles-dir profiles --target bigquery

generate:
	bash -x scripts/generate_secured_models.sh --vars-path ./resources/vars/vars-bigquery.basic.yml --target bigquery

run-unit-tests:
	bash run_unit_tests.sh --target bigquery --vars-path resources/vars/vars-bigquery.basic.yml

run-integration-tests:
	bash run_integration_tests.sh --target bigquery --vars-path ./resources/vars/vars-bigquery.basic.yml

test-get_tags_by_original_file_paths: setup
	dbt run-operation --profiles-dir ./profiles \
		--target bigquery \
		--vars "$$(cat "./resources/vars/vars-bigquery.basic.yml")" \
		--args '{"original_file_paths":["models/restricted_layer/dbt_data_privacy_restricted_layer/consents/restricted_layer__dbt_data_privacy_restricted_layer__consents.sql"]}' \
		get_tags_by_original_file_paths

compile: setup
	dbt compile --profiles-dir ./profiles \
		--target bigquery \
		--vars "$$(cat "./resources/vars/vars-bigquery.basic.yml")"
