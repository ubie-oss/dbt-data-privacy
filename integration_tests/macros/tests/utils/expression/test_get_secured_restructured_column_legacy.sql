{% macro test_get_secured_restructured_column_legacy() %}
  {{ return(adapter.dispatch("test_get_secured_restructured_column_legacy", "dbt_data_privacy_integration_tests")()) }}
{% endmacro %}

{% macro bigquery__test_get_secured_restructured_column_legacy()  %}
  {% set data_handling_standards = get_test_data_handling_standards() %}
  {% set columns = {
    'user_id': {
      'name': 'user_id',
      'description': 'User ID',
      'meta': {
        'data_privacy': {'level': 'confidential'}
      },
      'data_type': None,
      'quote': None,
      'tags': []
    },
    'consent.data_analysis': {
      'name': 'consent.data_analysis',
      'description': 'Consent agree of data analysis',
      'meta': {
        'data_privacy': {'level': 'internal'}
      },
      'data_type': None,
      'quote': None,
      'tags': []
    },
    'consent.data_sharing': {
      'name': 'consent.data_sharing',
      'description': 'Consent agree of data sharing',
      'meta': {
        'data_privacy': {'level': 'confidential'}
      },
      'data_type': None,
      'quote': None, 'tags': []
    }
  } %}
  {% set restructured_columns = dbt_data_privacy.restructure_columns(columns) %}

  {% set result = dbt_data_privacy.get_secured_restructured_column(
      data_handling_standards=data_handling_standards,
      column_conditions={},
      restructured_column=restructured_columns["user_id"],
      relative_path=["user_id"],
      depth=0
    ) %}
  {% set expected = {
    'original_info': {
      'name': 'user_id',
      'description': 'User ID',
      'meta': {
        'data_privacy': {'level': 'confidential'}
      },
      'data_type': None,
      'quote': None,
      'tags': []
    },
    'additional_info': {
      'relative_path': ['user_id'],
      'secured_expression': 'SHA256(CAST(user_id AS STRING))',
      'level': 'internal'
    }
  } %}
  {{ assert_equals(result, expected) }}

  {% set result = dbt_data_privacy.get_secured_restructured_column(
      data_handling_standards=data_handling_standards,
      column_conditions={},
      restructured_column=restructured_columns["consent"]["fields"]["data_analysis"],
      relative_path=["consent", "data_analysis"],
      depth=0
    ) %}
  {% set expected = {
    'original_info': {
      'name': 'consent.data_analysis',
      'description': 'Consent agree of data analysis',
      'meta': {
        'data_privacy': {'level': 'internal'}
      },
      'data_type': None,
      'quote': None,
      'tags': []
    },
    'additional_info': {
      'relative_path': ['consent', 'data_analysis'],
      'secured_expression': 'consent.data_analysis',
      'level': 'internal'
    }
  } %}
  {{ assert_equals(result, expected) }}

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

  {% set result = dbt_data_privacy.get_secured_restructured_column(
      data_handling_standards=data_handling_standards,
      column_conditions={},
      restructured_column=restructured_columns["struct1"]["fields"]["x"],
      relative_path=["struct1", "x"],
      depth=0
    ) %}
  {% set expected = {
    'original_info': {
      'name': 'struct1.x',
      'description': '',
      'meta': {
        'data_privacy': {'level': 'confidential'}
      },
      'data_type': None,
      'quote': None,
      'tags': []
    },
    'additional_info': {
      'relative_path': ['struct1', 'x'],
      'secured_expression': 'SHA256(CAST(struct1.x AS STRING))',
      'level': 'internal'
    }
  } %}
  {{ assert_equals(result, expected) }}

  {% set result = dbt_data_privacy.get_secured_restructured_column(
      data_handling_standards=data_handling_standards,
      column_conditions={},
      restructured_column=restructured_columns["struct1"]["fields"]["y"],
      relative_path=["struct1", "y"],
      depth=0
    ) %}
  {% set expected = {
    'original_info': {
      'name': 'struct1.y',
      'description': '',
      'meta': {
        'data_privacy': {'level': 'internal'}
      },
      'data_type': None,
      'quote': None,
      'tags': []
    },
    'additional_info': {
      'relative_path': ['struct1', 'y'],
      'secured_expression': 'struct1.y',
      'level': 'internal'
    }
  } %}
  {{ assert_equals(result, expected) }}

  {% set result = dbt_data_privacy.get_secured_restructured_column(
      data_handling_standards=data_handling_standards,
      column_conditions={},
      restructured_column=restructured_columns["array1"],
      relative_path=["array1"],
      depth=0
    ) %}
  {% set expected = {
    'original_info': {
      'name': 'array1',
      'description': '',
      'meta': {},
      'data_type': 'ARRAY',
      'quote': None,
      'tags': []
    },
    'additional_info': {'relative_path': ['array1']},
    'fields': {
      'x': {
        'original_info': {
          'name': 'array1.x',
          'description': '',
          'meta': {
            'data_privacy': {'level': 'confidential'}
          },
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
          'meta': {
            'data_privacy': {'level': 'confidential'}
          },
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
           'meta': {
             'data_privacy': {'level': 'internal'}
           },
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
  } %}
  {{ assert_equals(result, expected) }}
{% endmacro %}
