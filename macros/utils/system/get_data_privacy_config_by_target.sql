{% macro get_data_privacy_config_by_target(target, with_default_config=true) %}
  {% set data_privacy_configs = dbt_data_privacy.get_data_privacy_configs() %}

  {% if target not in data_privacy_configs %}
    {{ exceptions.raise_compiler_error("key {} doesn't exist in {}".format(target, data_privacy_configs)) }}
  {% endif %}
  {% set config_by_target = data_privacy_configs.get(target) %}

  {# fill in default values #}
  {% if with_default_config is true %}
    {% set default_config = dbt_data_privacy.get_default_data_privacy_config() %}
    {% for k, v in default_config.items() %}
      {% if k not in config_by_target %}
        {% do config_by_target.update({k: v}) %}
      {% endif %}
    {% endfor %}
  {% endif %}

  {{ return(config_by_target) }}
{% endmacro %}
