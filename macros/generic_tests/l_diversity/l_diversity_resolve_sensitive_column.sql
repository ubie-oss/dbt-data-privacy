{# Resolve which model column is the sensitive attribute for l-diversity (compile-time only). #}
{% macro l_diversity_resolve_sensitive_column(sensitive_column, column_name) %}
  {%- if sensitive_column is not none and sensitive_column is string -%}
    {%- set s = sensitive_column | trim -%}
    {%- if s | length > 0 -%}
      {{ return(s) }}
    {%- endif -%}
  {%- endif -%}
  {%- if column_name is not none and column_name is string -%}
    {%- set c = column_name | trim -%}
    {%- if c | length > 0 -%}
      {{ return(c) }}
    {%- endif -%}
  {%- endif -%}
  {{ exceptions.raise_compiler_error(
    "l_diversity: set sensitive_column in test arguments, or declare the test under columns: so dbt passes column_name"
  ) }}
{% endmacro %}
