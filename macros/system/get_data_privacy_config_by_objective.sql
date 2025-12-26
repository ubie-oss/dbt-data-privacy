{% macro get_data_privacy_config_by_objective(objective, with_default_config=true) %}
  {% set data_privacy_configs = dbt_data_privacy.get_data_privacy_configs() %}

  {% if objective not in data_privacy_configs %}
    {{ exceptions.raise_compiler_error("key {} doesn't exist in {}".format(objective, data_privacy_configs)) }}
  {% endif %}
  {% set config_by_objective = data_privacy_configs.get(objective) %}

  {# fill in default values #}
  {% if with_default_config is true %}
    {% set default_config = dbt_data_privacy.get_default_data_privacy_config() %}
    {# Iterate over keys for consistency #}
    {% for k in default_config %}
      {% set v = default_config[k] %}
      {% if k not in config_by_objective %}
        {% do config_by_objective.update({k: v}) %}
      {% endif %}
    {% endfor %}
  {% endif %}

  {{ return(config_by_objective) }}
{% endmacro %}
