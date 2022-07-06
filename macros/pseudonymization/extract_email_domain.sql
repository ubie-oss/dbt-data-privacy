{% macro extract_email_domain(expression) %}
  {{- return(adapter.dispatch('extract_email_domain', 'dbt_data_privacy')(expression)) -}}
{% endmacro %}

{% macro bigquery__extract_email_domain(expression) %}
  {% set secured_expression -%}
  IF({{ expression }} LIKE "%@%", SPLIT({{ expression }}, "@")[OFFSET(0)], {{ expression }})
  {%- endset %}
  {{- return(secured_expression) -}}
{% endmacro %}
