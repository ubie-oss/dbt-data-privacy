{% macro get_data_privacy_configs() %}
  {% set data_privacy_configs = var("data_privacy", {}) %}
  {{ return(data_privacy_configs) }}
{% endmacro %}

{% macro get_targets() %}
  {% set targets = [] %}

  {% set data_privacy_configs = dbt_data_privacy.get_data_privacy_configs() %}
  {% for target, v in data_privacy_configs.items() %}
    {% do targets.append(target) %}
  {% endfor %}

  {{ return(targets) }}
{% endmacro %}

{% macro get_data_privacy_config_by_target(target, with_default_config=true) %}
  {% set data_privacy_configs = dbt_data_privacy.get_data_privacy_configs() %}
  {% if target not in data_privacy_configs %}
    {{ exceptions.raise_compiler_error("key {} doesn't exist in {}".format(target, data_privacy_configs)) }}
  {% endif %}
  {% set config_by_target = data_privacy_configs.get(target) %}

  {# fill in default values #}
  {% if with_default_config is true %}
    {% set default_config = dbt_data_privacy.get_default_config() %}
    {% for k, v in default_config.items() %}
      {% if k not in config_by_target %}
        {% do config_by_target.update({k: v}) %}
      {% endif %}
    {% endfor %}
  {% endif %}

  {{ return(config_by_target) }}
{% endmacro %}

{% macro get_default_config() %}
  {% set default_config = {
      "materialization": "view",
      "tag": "generated_by_dbt_data_privacy",
    }
  %}
  {{ return(default_config) }}
{% endmacro %}
