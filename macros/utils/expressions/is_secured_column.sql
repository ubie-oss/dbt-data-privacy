{% macro is_secured_column(data_handling_standards, column) %}
  {# Get the data security level #}
  {% set level = dbt_data_privacy.get_data_security_level(colum) %}
{% endmacro %}
