{% macro test_restructure_secured_columns() %}
  {% set secured_columns = {
      "id": {
        "secured_expression": "id",
        "level": "internal"
      },
      "user_id": {
        "secured_expression": "SHA256(user_id)",
        "level": "internal"
      },
      "consents.data_analysis": {
        "secured_expression": "consents.data_analysis",
        "level": "internal"
      },
      "consents.data_sharing": {
        "secured_expression": "consents.data_sharing",
        "level": "internal"
      },
    }
  %}
  {% set result = dbt_data_privacy.restructure_secured_columns(secured_columns) %}
  {% set expected = {
    'id': {
      'secured_expression': 'id',
      'level': 'internal'
      },
    'user_id': {
      'secured_expression': 'SHA256(user_id)',
      'level': 'internal'
      },
    'consents': {
      'data_analysis': {
        'secured_expression': 'consents.data_analysis',
        'level': 'internal'
        },
      'data_sharing': {
        'secured_expression': 'consents.data_sharing',
        'level': 'internal'
        }
      }
    }
  %}

  {{ assert_dict_equals(result, expected) }}
{% endmacro %}
