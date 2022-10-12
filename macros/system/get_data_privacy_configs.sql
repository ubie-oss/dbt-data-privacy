{% macro get_data_privacy_configs() %}
  {% set data_privacy_configs = var("data_privacy", {}) %}
  {{ return(data_privacy_configs) }}
{% endmacro %}
