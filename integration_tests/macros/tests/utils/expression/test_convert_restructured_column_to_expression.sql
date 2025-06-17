{% macro test_convert_restructured_column_to_expression() %}
  {{ return(adapter.dispatch("test_convert_restructured_column_to_expression", "dbt_data_privacy_integration_tests")()) }}
{% endmacro %}

{% macro bigquery__test_convert_restructured_column_to_expression() %}
  {% set data_handling_standards = get_test_data_handling_standards() %}
  {% set columns = {
    'struct1.x': {
      'name': 'struct1.x',
      'description': '',
      'config': {
        'meta': {
          'data_privacy': {'level': 'confidential'}
        },
      },
      'data_type': None,
      'quote': None,
      'tags': []
    },
    'struct1.y': {
      'name': 'struct1.y',
      'description': '',
      'config': {
        'meta': {
          'data_privacy': {'level': 'internal'}
        },
      },
      'data_type': None,
      'quote': None,
      'tags': []
    },
    'struct1.z': {
      'name': 'struct1.z',
      'description': '',
      'config': {
        'meta': {},
      },
      'data_type': None,
      'quote': None,
      'tags': []
    },
    'array1': {
      'name': 'array1',
      'description': '',
      'config': {
        'meta': {},
      },
      'data_type': "ARRAY",
      'quote': None,
      'tags': []
    },
    'array1.x': {
      'name': 'array1.x',
      'description': '',
      'config': {
        'meta': {
          'data_privacy': {'level': 'confidential'}
        },
      },
      'data_type': "ARRAY",
      'quote': None,
      'tags': []
    },
    'array1.y': {
      'name': 'array1.y',
      'description': '',
      'config': {
        'meta': {
          'data_privacy': {'level': 'confidential'}
        },
      },
      'data_type': None,
      'quote': None,
      'tags': []
    },
    'array1.z': {
      'name': 'array1.z',
      'description': '',
      'config': {
        'meta': {
          'data_privacy': {'level': 'internal'}
        },
      },
      'data_type': None,
      'quote': None,
      'tags': []
    },
    'array1.struct1.x': {
      'name': 'array1.struct1.x',
      'description': '',
      'config': {
        'meta': {
          'data_privacy': {'level': 'confidential'}
        },
      },
      'data_type': "ARRAY",
      'quote': None,
      'tags': []
    },
    'array1.struct1.array2': {
      'name': 'array1.struct1.array2',
      'description': '',
      'config': {
        'meta': {},
      },
      'data_type': "ARRAY",
      'quote': None,
      'tags': []
    },
    'array1.struct1.array2.y': {
      'name': 'array1.struct1.array2.y',
      'description': '',
      'config': {
        'meta': {
          'data_privacy': {'level': 'confidential'}
        },
      },
      'data_type': "ARRAY",
      'quote': None,
      'tags': []
    },
    'array1.struct1.array2.z': {
      'name': 'array1.struct1.array2.z',
      'description': '',
      'config': {
        'meta': {},
      },
      'data_type': None,
      'quote': None,
      'tags': []
    },
  } %}

  {% set restructured_columns = dbt_data_privacy.get_secured_columns_v2(
      data_handling_standards=data_handling_standards,
      columns=columns
    ) %}

  {% set result = dbt_data_privacy.convert_restructured_column_to_expression(
      "struct1", restructured_columns["struct1"], depth=0, indent=false) %}
  {%- set expected -%}
  STRUCT(
    SHA256(CAST(struct1.x AS STRING)) AS `x`,
    struct1.y AS `y`
  ) AS `struct1`
  {%- endset %}
  {{ assert_equals(result | replace(" ", ""), expected | replace(" ", "")) }}

  {%- set result = dbt_data_privacy.convert_restructured_column_to_expression(
      "array1", restructured_columns["array1"], depth=0, indent=false) -%}
  {%- set expected -%}
  ARRAY(
    SELECT
      STRUCT(
        ARRAY(SELECT SHA256(CAST(e AS STRING)) FROM UNNEST(x) AS e) AS `x`,
        SHA256(CAST(y AS STRING)) AS `y`,
        z AS `z`,
        STRUCT(
          ARRAY(SELECT SHA256(CAST(e AS STRING)) FROM UNNEST(struct1.x) AS e) AS `x`,
          ARRAY(
              SELECT
                STRUCT(
                  ARRAY(SELECT SHA256(CAST(e AS STRING)) FROM UNNEST(y) AS e) AS `y`
                )
              FROM UNNEST(struct1.array2)
          ) AS `array2`
        ) AS `struct1`
      )
    FROM UNNEST(array1)
  ) AS `array1`
  {%- endset -%}
  {{ assert_equals(result | replace(" ", ""), expected | replace(" ", "")) }}
{% endmacro %}
