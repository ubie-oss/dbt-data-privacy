{% macro test_has_sub_fields() %}
  {% set target_column_name = "a" %}
  {% set dummy_columns = {
    "b.c": {
      'data_type': none,
      'name': "b.c",
      'meta': {},
    }
  } %}
  {{ assert_equals(dbt_data_privacy.has_sub_fields(target_column_name, dummy_columns), false) }}
  {% set dummy_columns = {
    "a.b.c": {
      'data_type': none,
      'name': "a.b.c",
      'meta': {},
    }
  } %}
  {{ assert_equals(dbt_data_privacy.has_sub_fields(target_column_name, dummy_columns), true) }}

  {% set target_column_name = "a.b" %}
  {% set dummy_columns = {
    "b.c": {
      'data_type': none,
      'name': "b.c",
      'meta': {},
    }
  } %}
  {{ assert_equals(dbt_data_privacy.has_sub_fields(target_column_name, dummy_columns), false) }}
  {% set dummy_columns = {
    "a.b.c": {
      'data_type': none,
      'name': "a.b.c",
      'meta': {},
    }
  } %}
  {{ assert_equals(dbt_data_privacy.has_sub_fields(target_column_name, dummy_columns), true) }}
{% endmacro %}
