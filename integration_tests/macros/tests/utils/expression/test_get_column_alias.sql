{% macro test_get_column_alias() %}
  {% set column_info_with_config = {
    'config': {
      'meta': {
        'data_privacy': {'alias': 'aliased_name'}
      }
    }
  } %}
  {% set result = dbt_data_privacy.get_column_alias(column_info_with_config) %}
  {{ assert_equals(result, 'aliased_name') }}

  {% set column_info_with_meta = {
    'meta': {
      'data_privacy': {'alias': 'aliased_name_legacy'}
    }
  } %}
  {% set result = dbt_data_privacy.get_column_alias(column_info_with_meta) %}
  {{ assert_equals(result, 'aliased_name_legacy') }}

  {% set column_info_with_both = {
    'config': {
      'meta': {
        'data_privacy': {'alias': 'aliased_name'}
      }
    },
    'meta': {
      'data_privacy': {'alias': 'aliased_name_legacy'}
    }
  } %}
  {% set result = dbt_data_privacy.get_column_alias(column_info_with_both) %}
  {{ assert_equals(result, 'aliased_name') }}

  {% set column_info_without_alias = {
    'config': {
      'meta': {
        'data_privacy': {'level': 'internal'}
      }
    }
  } %}
  {% set result = dbt_data_privacy.get_column_alias(column_info_without_alias) %}
  {{ assert_equals(result, none) }}

  {% set column_info_empty = {} %}
  {% set result = dbt_data_privacy.get_column_alias(column_info_empty) %}
  {{ assert_equals(result, none) }}
{% endmacro %}
