{% macro get_default_tag(data_privacy_config) %}
  {% if "default_tag" not in data_privacy_config %}
    {{ exceptions.raise_compiler_error("'default_tag' doesn't exist in {}".format(data_privacy_config)) }}
  {% endif %}
  {{ return(data_privacy_config.get("default_tag")) }}
{% endmacro %}
