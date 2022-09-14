{% macro is_secured_column(column) %}
  {# Get the data security level #}
  {% set level = dbt_data_privacy.get_data_security_level(colum) %}
{% endmacro %}

{% macro get_data_security_level(column) %}
  {% set level = none %}
  {% if not column.meta.data_privacy or none column.meta.data_privacy.level  %}
    {{  log("column {} doesn't have the data security level.".format(column.name)) }}
  {% else %}
    {% set level = column.meta.data_privacy.level %}
  {% endif %}
  {{ return(level) }}
{% endmacro %}
