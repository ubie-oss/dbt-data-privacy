{% macro test_flatten_restructured_columns_for_schema() %}
  {{ return(adapter.dispatch("test_flatten_restructured_columns_for_schema", "dbt_data_privacy_integration_tests")()) }}
{% endmacro %}

{% macro bigquery__test_flatten_restructured_columns_for_schema() %}
  {% set data_handling_standards = get_test_data_handling_standards() %}
  {% set columns = {
    'struct1.x': {
      'name': 'struct1.x',
      'description': '',
      'meta': {
        'data_privacy': {'level': 'confidential'}
      },
      'data_type': None,
      'quote': None,
      'tags': []
    },
    'struct1.y': {
      'name': 'struct1.y',
      'description': '',
      'meta': {
        'data_privacy': {'level': 'internal'}
      },
      'data_type': None,
      'quote': None,
      'tags': []
    },
    'array1': {
      'name': 'array1',
      'description': '',
      'meta': {},
      'data_type': "ARRAY",
      'quote': None,
      'tags': []
    },
    'array1.x': {
      'name': 'array1.x',
      'description': '',
      'meta': {
        'data_privacy': {'level': 'confidential'}
      },
      'data_type': "ARRAY",
      'quote': None,
      'tags': []
    },
    'array1.y': {
      'name': 'array1.y',
      'description': '',
      'meta': {
        'data_privacy': {'level': 'confidential'}
      },
      'data_type': None,
      'quote': None,
      'tags': []
    },
    'array1.z': {
      'name': 'array1.z',
      'description': '',
      'meta': {
        'data_privacy': {'level': 'internal'}
      },
      'data_type': None,
      'quote': None,
      'tags': []
    },
    'array1.a': {
      'name': 'array1.a',
      'description': '',
      'meta': {
        'data_privacy': {'level': 'restricted'}
      },
      'data_type': None,
      'quote': None,
      'tags': []
    },
    'array1.b': {
      'name': 'array1.b',
      'description': '',
      'meta': {},
      'data_type': None,
      'quote': None,
      'tags': []
    },
  } %}

  {% set restructured_columns = dbt_data_privacy.get_secured_columns_v2(
      data_handling_standards=data_handling_standards, columns=columns) %}

  {% set result = dbt_data_privacy.flatten_restructured_columns_for_schema(restructured_columns) %}
  {% set expected = {
    'struct1.x': {'name': 'struct1.x', 'description': '', 'meta': {'data_privacy': {'level': 'internal'}}, 'data_type': None, 'quote': None, 'tags': []},
    'struct1.y': {'name': 'struct1.y', 'description': '', 'meta': {'data_privacy': {'level': 'internal'}}, 'data_type': None, 'quote': None, 'tags': []},
    'array1.x': {'name': 'array1.x', 'description': '', 'meta': {'data_privacy': {'level': 'internal'}}, 'data_type': 'ARRAY', 'quote': None, 'tags': []},
    'array1.y': {'name': 'array1.y', 'description': '', 'meta': {'data_privacy': {'level': 'internal'}}, 'data_type': None, 'quote': None, 'tags': []},
    'array1.z': {'name': 'array1.z', 'description': '', 'meta': {'data_privacy': {'level': 'internal'}}, 'data_type': None, 'quote': None, 'tags': []}
  } %}
  {{ assert_dict_equals(result, expected) }}
{% endmacro %}
