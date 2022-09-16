{% macro analyze_column_conditions(columns) %}
  {% set conditions = {
      'contains_pseudonymized_unique_identifiers': dbt_data_privacy.contains_pseudonymized_unique_identifiers(columns),
    }
  %}
  {{ return(conditions) }}
{% endmacro %}

{% macro contains_pseudonymized_unique_identifiers(columns) %}
  {% set columns_with_policy_tags = dbt_data_privacy.get_columns_by_policy_tag(columns, "unique_identifier") %}
  {% if columns_with_policy_tags | length > 0 %}
    {{ return(true) }}
  {% else %}
    {{ return(false) }}
  {% endif %}
{% endmacro %}
