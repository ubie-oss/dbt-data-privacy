{% macro test_convert_to_nested_dict() %}
  {% set keys = "column1".split(".") %}
  {% set v = {
      'name': 'column1',
      'description': 'Column 1',
      'meta': {
        'data_privacy': {'level': 'confidential'}
      },
      'data_type': None,
      'quote': None,
      'tags': []
    }
  %}
  {% set result = dbt_data_privacy.convert_to_nested_dict(keys, v) %}
  {% set expected = {
    'column1': {
      'name': 'column1',
      'description': 'Column 1',
      'meta': {'data_privacy': {'level': 'confidential'}},
      'data_type': None,
      'quote': None,
      'tags': []
    }
  } %}
  {{ assert_dict_equals(result, expected) }}

  {% set keys = "column1.column2".split(".") %}
  {% set v = {
      'name': 'column1.column2',
      'description': 'Column 2',
      'meta': {
        'data_privacy': {'level': 'confidential'}
      },
      'data_type': "ARRAY",
      'quote': None,
      'tags': []
    }
  %}
  {% set result = dbt_data_privacy.convert_to_nested_dict(keys, v) %}
  {% set expected = {
    'column1': {
      'fields': {
        'column2': {
          'name': 'column1.column2',
          'description': 'Column 2',
          'meta': {'data_privacy': {'level': 'confidential'}},
          'data_type': 'ARRAY',
          'quote': None,
          'tags': []
        }
      }
    }
  } %}
  {{ assert_dict_equals(result, expected) }}

{% endmacro %}
