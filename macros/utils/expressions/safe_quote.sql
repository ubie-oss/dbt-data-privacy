{% macro safe_quote(expression, quote='"') %}
  {% if dbt_data_privacy.is_macro_expression(expression) %}
    {{ return(expression) }}
  {% endif %}
  {{ return(quote ~ expression ~ quote) }}
{% endmacro %}
