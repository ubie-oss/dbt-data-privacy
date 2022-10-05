{% macro get_column_data_security_level(column_info) %}
  {% if column_info.meta is defined
        and column_info.meta is mapping
        and column_info.meta.data_privacy is defined
        and column_info.meta.data_privacy is mapping
        and column_info.meta.data_privacy.level is defined %}
    {{ return(column_info.meta.data_privacy.level) }}
  {% endif %}

  {{ return(none) }}
{% endmacro %}
