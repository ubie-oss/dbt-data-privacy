{% macro get_data_security_level(column) %}
  {% set level = none %}
  {% if column.meta is defined
        and column.meta.data_privacy is defined
        and column.meta.data_privacy.level is defined %}
    {% set level = column.meta.data_privacy.level %}
  {% else %}
    {%- do exceptions.warn("column {} doesn't have the data security level.".format(column.name)) -%}
  {% endif %}
  {{ return(level) }}
{% endmacro %}
