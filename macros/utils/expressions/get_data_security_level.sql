{% macro get_data_security_level(column) %}
  {% set level = none %}

  {# Try new dbt 1.10+ format first (config.meta) #}
  {% if column.config is defined
        and column.config is mapping
        and column.config.meta is defined
        and column.config.meta is mapping
        and column.config.meta.data_privacy is defined
        and column.config.meta.data_privacy is mapping
        and column.config.meta.data_privacy.level is defined %}
    {% set level = column.config.meta.data_privacy.level %}
  {# Fall back to old format (meta) for backward compatibility #}
  {% elif column.meta is defined
        and column.meta.data_privacy is defined
        and column.meta.data_privacy.level is defined %}
    {% set level = column.meta.data_privacy.level %}
  {% else %}
    {%- do exceptions.warn("column {} doesn't have the data security level.".format(column.name)) -%}
  {% endif %}
  {{ return(level) }}
{% endmacro %}
