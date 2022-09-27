{% macro analyze_column_conditions(data_handling_standards, columns) %}
  {% set conditions = {
      'contains_pseudonymized_unique_identifiers': dbt_data_privacy.contains_pseudonymized_unique_identifiers(data_handling_standards, columns),
    }
  %}
  {{ return(conditions) }}
{% endmacro %}
