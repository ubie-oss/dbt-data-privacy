{% macro test_get_secured_columns() %}
  {{ return(adapter.dispatch("test_get_secured_columns", "dbt_data_privacy_integration_tests")()) }}
{% endmacro %}

{% macro bigquery__test_get_secured_columns() %}
  {% set data_handling_standards = get_test_data_handling_standards() %}
  {% set columns = {
    'user_id': {
      'name': 'user_id',
      'description': 'User ID',
      'config': {
        'meta': {
          'data_privacy': {'level': 'confidential', 'policy_tags': ['unique_identifier']}
        }
      },
      'data_type': None,
      'quote': None,
      'tags': []
    },
    'pseudonymized_user_id': {
      'name': 'pseudonymized_user_id',
      'description': 'Pseudonymized user ID',
      'config': {
        'meta': {}
      },
      'data_type': None,
      'quote': None,
      'tags': []
    },
    'consent.data_analysis': {
      'name': 'consent.data_analysis',
      'description': 'Consent agree of data analysis',
      'config': {
        'meta': {'data_privacy': {'level': 'internal'}}
      },
      'data_type': None,
      'quote': None,
      'tags': []
    },
    'consent.data_sharing': {
      'name': 'consent.data_sharing',
      'description': 'Consent agree of data sharing',
      'config': {
        'meta': {'data_privacy': {'level': 'confidential'}}
      },
      'data_type': None,
      'quote': None,
      'tags': []
    },
    'dummy_array': {
      'name': 'dummy_array',
      'description': 'Test array',
      'config': {
        'meta': {'data_privacy': {'level': 'confidential'}}
      },
      'data_type': 'ARRAY',
      'quote': None,
      'tags': []
    }
  } %}

  {% set result = dbt_data_privacy.get_secured_columns(data_handling_standards, columns) %}
  {% set expected = {
    'user_id': { 'secured_expression': 'SHA256(CAST(user_id AS STRING))', 'level': 'internal' },
    'consent.data_analysis': {'secured_expression': 'consent.data_analysis', 'level': 'internal'},
    'consent.data_sharing': {'secured_expression': 'SHA256(CAST(consent.data_sharing AS STRING))', 'level': 'internal'},
    'dummy_array': {'secured_expression': 'ARRAY(SELECT SHA256(CAST(e AS STRING)) FROM UNNEST(dummy_array) AS e)', 'level': 'internal'}
  } %}
  {{ assert_dict_equals(result, expected) }}
{% endmacro %}
