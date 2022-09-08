{% macro analyze_column_conditions(columns) %}
  {% set conditions = {
      'contains_pseudonymized_unique_identifiers': dbt_data_privacy.contains_pseudonymized_unique_identifiers(columns),
    }
  %}
  {{ return(conditions) }}
{% endmacro %}

{% macro contains_pseudonymized_unique_identifiers(columns) %}
  {{ return(true) }}
{% endmacro %}
