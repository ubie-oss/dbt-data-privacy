{% macro test_create_deep_dict() %}
  {% set keys = "x".split(".") %}
  {% set v = {
      "secured_expression": "x",
      "level": "internal",
    }
  %}
  {% set result = dbt_data_privacy.create_deep_dict(keys, v) %}
  {% set expected = {'x': {'secured_expression': 'x', 'level': 'internal'}} %}

  {{ assert_dict_equals(result, expected) }}
  {% set keys = "x.y".split(".") %}
  {% set v = {
      "secured_expression": "x.y",
      "level": "internal",
    }
  %}
  {% set result = dbt_data_privacy.create_deep_dict(keys, v) %}
  {% set expected = {'x': {'y': {'secured_expression': 'x.y', 'level': 'internal'}}} %}
  {{ assert_dict_equals(result, expected) }}

  {{ assert_dict_equals(result, expected) }}
  {% set keys = "x.y.z".split(".") %}
  {% set v = {
      "secured_expression": "x.y.z",
      "level": "internal",
    }
  %}
  {% set result = dbt_data_privacy.create_deep_dict(keys, v) %}
  {% set expected = {'x': {'y': {'z': {'secured_expression': 'x.y.z', 'level': 'internal'}}}} %}
  {{ assert_dict_equals(result, expected) }}
{% endmacro %}
