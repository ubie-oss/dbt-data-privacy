{% macro test_get_columns_by_policy_tag_legacy() %}
  {% set columns = {
    'user_id': {
      'name': 'user_id',
      'description': 'User ID',
      'meta': {
        'data_privacy': {'level': 'confidential', 'policy_tags': ['unique_identifier']}
      },
      'data_type': None,
      'quote': None,
      'tags': []
    },
    'pseudonymized_user_id': {
      'name': 'pseudonymized_user_id',
      'description': 'Pseudonymized user ID',
      'meta': {'data_privacy': {'level': 'internal'}},
      'data_type': None,
      'quote': None,
      'tags': []
    },
    'consent.data_analysis': {
      'name': 'consent.data_analysis',
      'description': 'Consent agree of data analysis',
      'meta': {'data_privacy': {'level': 'internal'}},
      'data_type': None,
      'quote': None,
      'tags': []
    },
    'consent.data_sharing': {
      'name': 'consent.data_sharing',
      'description': 'Consent agree of data sharing',
      'meta': {'data_privacy': {'level': 'internal'}},
      'data_type': None,
      'quote': None,
      'tags': []
    },
    'dummy_array': {
      'name': 'dummy_array',
      'description': 'Test array',
      'meta': {'data_privacy': {'level': 'internal'}},
      'data_type': 'ARRAY',
      'quote': None,
      'tags': []
    }
  } %}
  {% set results = dbt_data_privacy.get_columns_by_policy_tag(columns, 'unique_identifier')  %}
  {{ assert_equals(results | length, 1) }}
  {% set expected = {"user_id": columns.get("user_id")} %}
  {{ assert_dict_equals(results, expected) }}
{% endmacro %}
