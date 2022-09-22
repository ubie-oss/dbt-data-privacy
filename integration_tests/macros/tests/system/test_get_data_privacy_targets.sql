{% macro test_get_data_privacy_objectives() %}
  {% set result = dbt_data_privacy.get_data_privacy_objectives() %}
  {% set expected = ['data_analysis'] %}

  {{ assert_equals(result, expected) }}
{% endmacro %}
