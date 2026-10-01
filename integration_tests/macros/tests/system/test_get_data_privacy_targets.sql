{% macro test_get_data_privacy_objectives() %}
  {% set result = dbt_data_privacy.get_data_privacy_objectives() %}
  {% set expected = ['data_analysis', 'column_exposure'] %}

  {{ assert_equals(result, expected) }}

  {% set data_analysis = dbt_data_privacy.get_data_privacy_config_by_objective('data_analysis') %}
  {% set data_analysis_conditions = data_analysis['data_handling_standards']['restricted']['with']['conditions'] %}
  {{ assert_equals(data_analysis_conditions, ['contains_pseudonymized_unique_identifiers']) }}

  {% set column_exposure = dbt_data_privacy.get_data_privacy_config_by_objective('column_exposure') %}
  {% set column_exposure_conditions = column_exposure['data_handling_standards']['restricted']['with']['conditions'] %}
  {{ assert_equals(
      column_exposure_conditions,
      ['contains_pseudonymized_unique_identifiers', 'is_column_exposable']) }}
{% endmacro %}
