{% macro get_enabled_policy_tags(data_privacy_config) %}
  {% if data_privacy_config is not mapping %}
    {% do exceptions.raise_compiler_error("data_privacy_config {} is not mapping".format(data_privacy_config)) %}
  {% endif %}

  {{ return(data_privacy_config.get("enabled_policy_tags", [])) }}
{% endmacro %}
