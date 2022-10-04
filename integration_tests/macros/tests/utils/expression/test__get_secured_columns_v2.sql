{% macro test_get_secured_columns_v2() %}
  {{ return(adapter.dispatch("test_get_secured_columns_v2", "dbt_data_privacy_integration_tests")()) }}
{% endmacro %}

{% macro bigquery__test_get_secured_columns_v2() %}
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
  } %}
  {% set restructured_columns = dbt_data_privacy.restructure_columns(columns) %}

  {% set result = dbt_data_privacy.get_secured_columns_v2(
      data_handling_standards=data_handling_standards,
      column_conditions={},
      restructured_columns=restructured_columns
    ) %}
  {% set expected = {
    'struct1': {
      'fields': {
        'x': {
          'original_info': {
            'name': 'struct1.x',
            'description': '',
            'meta': {'data_privacy': {'level': 'confidential'}},
            'data_type': None,
            'quote': None,
            'tags': []
          },
          'additional_info': {
            'relative_path': ['struct1', 'x'],
            'secured_expression': 'SHA256(CAST(struct1.x AS STRING))',
            'level': 'internal'
          }
        },
        'y': {
          'original_info': {
            'name': 'struct1.y',
            'description': '',
            'meta': {'data_privacy': {'level': 'internal'}},
            'data_type': None,
            'quote': None,
            'tags': []
          },
          'additional_info': {
            'relative_path': ['struct1', 'y'],
            'secured_expression': 'struct1.y',
            'level': 'internal'
          }
        }
      }
    },
    'array1': {
      'original_info': {
        'name': 'array1',
        'description': '',
        'meta': {},
        'data_type': 'ARRAY',
        'quote': None,
        'tags': []
      },
      'additional_info': {},
      'fields': {
        'x': {
          'original_info': {
            'name': 'array1.x',
            'description': '',
            'meta': {'data_privacy': {'level': 'confidential'}},
            'data_type': 'ARRAY',
            'quote': None,
            'tags': []
          },
          'additional_info': {
            'relative_path': ['x'],
            'secured_expression': 'ARRAY(SELECT SHA256(CAST(e AS STRING)) FROM UNNEST(x) AS e)',
            'level': 'internal'
          }
        },
        'y': {
          'original_info': {
            'name': 'array1.y',
            'description': '',
            'meta': {'data_privacy': {'level': 'confidential'}},
            'data_type': None,
            'quote': None,
            'tags': []
          },
          'additional_info': {
            'relative_path': ['y'],
            'secured_expression': 'SHA256(CAST(y AS STRING))',
            'level': 'internal'
          }
        },
        'z': {
          'original_info': {
            'name': 'array1.z',
            'description': '',
            'meta': { 'data_privacy': {'level': 'internal'} },
            'data_type': None,
            'quote': None,
            'tags': []
          },
          'additional_info': {
            'relative_path': ['z'],
            'secured_expression': 'z',
            'level': 'internal'
          }
        }
      }
    }
  } %}
  {{ assert_dict_equals(result, expected) }}


  {% set columns = {
    'struct1.x': {
      'name': 'struct1.x',
      'description': '',
      'meta': { 'data_privacy': {'level': 'confidential'} },
      'data_type': None,
      'quote': None,
      'tags': []
    },
    'struct1.struct2.x': {
      'name': 'struct1.struct11.scalar111',
      'description': '',
      'meta': { 'data_privacy': {'level': 'confidential'} },
      'data_type': None,
      'quote': None,
      'tags': []
    },
    'struct1.struct11.array111': {
      'name': 'struct1.struct11.array111',
      'description': '',
      'meta': {
        'data_privacy': {'level': 'confidential'}
      },
      'data_type': "ARRAY",
      'quote': None,
      'tags': []
    },
    'struct1.array1': {
      'name': 'struct1.array1',
      'description': '',
      'meta': {},
      'data_type': "ARRAY",
      'quote': None,
      'tags': []
    },
    'struct1.array1.scalar1': {
      'name': 'struct1.array1.',
      'description': '',
      'meta': {
        'data_privacy': {'level': 'internal'}
      },
      'data_type': None,
      'quote': None,
      'tags': []
    },
    'struct1.array1.struct2.x': {
      'name': 'struct1.y',
      'description': '',
      'meta': {
        'data_privacy': {'level': 'internal'}
      },
      'data_type': None,
      'quote': None,
      'tags': []
    },
  } %}
  {% set restructured_columns = dbt_data_privacy.restructure_columns(columns) %}
{% endmacro %}
