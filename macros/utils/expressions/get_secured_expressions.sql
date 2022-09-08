{% macro get_secured_expressions(columns, data_handling_standard) %}
  {% set secured_expressions = [] %}

  {%- for column_name, column_info in columns.items() -%}
    {%- if "data_privacy" in column_info.meta and column_info.meta.data_privacy.level %}
      {% set expression = dbt_data_privacy.get_secured_expression(
        column_name, column_info.meta.data_privacy.level) %}
      {%- if expression is not none -%}
        {{ expression }} AS `{{- column_name -}}`,
      {%- endif -%}
    {%- endif -%}
  {%- endfor %}

  {% do return(secured_expressions) %}
{% endmacro %}

{% macro with_pseudonymized_unique_identifiers(columns) %}
  {% set columns_with_policy_tag = dbt_data_privacy.get_columns_by_policy_tag(columns, policy_tag='unique_identifier') %}

  {% if columns_with_policy_tag | length > 0 %}
    {% do return(true) %}
  {% else %}
    {% do return(false) %}
  {% endif %}
{% endmacro %}
