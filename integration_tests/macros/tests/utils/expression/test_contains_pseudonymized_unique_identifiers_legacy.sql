{% macro test_contains_pseudonymized_unique_identifiers_legacy() %}
  {% set data_handling_standard = {
      "public": { "method": "RAW" },
      "internal": { "method": "RAW" },
      "confidential": { "method": "SHA256" },
      "restricted": {
        "method": "CONDITIONAL_HASH",
        "with": {
          "default_method": "SHA256",
          "condition": "contains_pseudonymized_unique_identifiers",
        },
      },
    } %}
  {% set columns = {
    'user_id': {
      'name': 'user_id',
      'description': 'User ID',
      'meta': {
        'data_privacy': {'level': 'confidential', 'policy_tags': ['unique_identifier']}},
        'data_type': None,
        'quote': None,
        'tags': []
      },
    'restricted_column': {
      'name': 'restricted_column',
      'description': 'restricted_column',
      'meta': {
        'data_privacy': {'level': 'restricted'},
        'data_type': None,
        'quote': None,
        'tags': []
      },
    }
  } %}
  {% set result = dbt_data_privacy.contains_pseudonymized_unique_identifiers(
        data_handling_standard=data_handling_standard, columns=columns)  %}
  {{ assert_equals(result, true) }}

  {% set columns = {
    'user_id': {
      'name': 'user_id',
      'description': 'User ID',
      'meta': {
        'data_privacy': {'level': 'internal'}},
        'data_type': None,
        'quote': None,
        'tags': []
      },
    'restricted_column': {
      'name': 'restricted_column',
      'description': 'restricted_column',
      'meta': {
        'data_privacy': {'level': 'restricted'},
        'data_type': None,
        'quote': None,
        'tags': []
      },
    }
  } %}
  {% set result = dbt_data_privacy.contains_pseudonymized_unique_identifiers(
        data_handling_standard=data_handling_standard, columns=columns)  %}
  {{ assert_equals(result, false) }}
{% endmacro %}
