{% macro test_get_data_privacy_configs() %}
  {% set result = dbt_data_privacy.get_data_privacy_configs() %}
  {% set expected = var('data_privacy', {}) %}
  {{ assert_dict_equals(result, expected) }}
{% endmacro %}
