{% macro test_format_model_config() %}
  {{- return(adapter.dispatch("test_format_model_config", "dbt_data_privacy_integration_tests")()) -}}
{% endmacro %}

{% macro bigquery__test_format_model_config() %}
  {% set model_config = {
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
      "no_such_config": 1,
    } %}
  {% set result = dbt_data_privacy.format_model_config(**model_config) %}
  {% set expected = {
      'materialized': 'view',
      'database': 'test-project',
      'schema': 'test_dataset',
      'alias': 'test_alias',
      'tags': ['tag1', 'tag1', 'generated_by_dbt_data_privacy'],
      'labels': {
        'key1': 'value1',
        'key2': 'value2',
      },
      'persist_docs': {'relation': True, 'columns': True},
      'full_refresh': None,
      'enabled': True,
      'adapter_config': {
        'partition_by': None,
        'cluster_by': None,
        'grant_access_to': [
          {'project': 'test-project1', 'database': 'test_dataset1'},
          {'project': 'test-project2', 'database': 'test_dataset2'},
        ],
      },
      'unknown_config': {
        'no_such_config': 1,
      },
    } %}
  {{ assert_dict_equals(result, expected) }}
{% endmacro %}
