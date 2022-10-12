{% macro get_default_materialization(data_privacy_config) %}
  {% if "default_materialization" not in data_privacy_config %}
    {{ exceptions.raise_compiler_error("'default_materialization' doesn't exist in {}".format(data_privacy_config)) }}
  {% endif %}
  {{ return(data_privacy_config.get("default_materialization")) }}
{% endmacro %}
