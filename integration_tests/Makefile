setup:
	pip install -r requirements/requirements-1.1.txt
	dbt deps --profiles-dir profiles --target bigquery

generate:
	bash scripts/generate_secured_models.sh --vars-path ./resources/vars/vars-bigquery.basic.yml --target bigquery

run-unit-tests:
	bash run_unit_tests.sh --target bigquery --vars-path resources/vars/vars-bigquery.basic.yml

run-integration-tests:
	bash run_integration_tests.sh --target bigquery --vars-path ./resources/vars/vars-bigquery.basic.yml
