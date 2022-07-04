{% macro test_extract_model_configurations() %}
  {{- return(adapter.dispatch("test_extract_model_configurations", "dbt_data_privacy_integration_tests")()) -}}
{% endmacro %}

{% macro bigquery__test_extract_model_configurations() %}
  {% set model_configurations = {
      "materialized": "view",
      "database": "test-project",
      "schema": "test_dataset",
      "alias": "test_alias",
      "tags": ["tag1", "tag1"],
      "labels": {
        "key1": "value1",
        "key2": "value2",
      },
      "grant_access_to": [
        {"project": "test-project1", "database": "test_dataset1"},
        {"project": "test-project2", "database": "test_dataset2"},
      ],
      "require_partition_filter": true,
      "partition_expiration_days": 7,
    } %}
  {% set result = dbt_data_privacy.extract_model_configurations(**model_configurations) %}
  {% set expected = {
      'materialized': 'view',
      'database': 'test-project',
      'schema': 'test_dataset',
      'alias': 'test_alias',
      'tags': ['tag1', 'tag1'],
      'labels': {'key1': 'value1', 'key2': 'value2'},
      'persist_docs': {'relation': True, 'columns': True},
      'full_refresh': None,
      'enabled': True,
      'partition_by': None,
      'cluster_by': None,
      'require_partition_filter': True,
      'grant_access_to': [
        {"project": "test-project1", "database": "test_dataset1"},
        {"project": "test-project2", "database": "test_dataset2"},
      ],
      'extra_configurations': {
        "partition_expiration_days": 7,
      },
    } %}
  {{ assert_dict_equals(result, expected) }}
{% endmacro %}
