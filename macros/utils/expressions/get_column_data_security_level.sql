{% macro get_column_data_security_level(column_info) %}
  {# Try new dbt 1.10+ format first (config.meta) #}
  {% if column_info.config is defined
        and column_info.config is mapping
        and column_info.config.meta is defined
        and column_info.config.meta is mapping
        and column_info.config.meta.data_privacy is defined
        and column_info.config.meta.data_privacy is mapping
        and column_info.config.meta.data_privacy.level is defined %}
    {{ return(column_info.config.meta.data_privacy.level) }}
  {% endif %}

  {# Fall back to old format (meta) for backward compatibility #}
  {% if column_info.meta is defined
        and column_info.meta is mapping
        and column_info.meta.data_privacy is defined
        and column_info.meta.data_privacy is mapping
        and column_info.meta.data_privacy.level is defined %}
    {{ return(column_info.meta.data_privacy.level) }}
  {% endif %}

  {{ return(none) }}
{% endmacro %}
