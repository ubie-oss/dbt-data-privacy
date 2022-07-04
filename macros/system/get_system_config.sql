{% macro get_system_config() %}
  {% set system_config_vars = dbt_data_privacy.get_system_config_block() %}
  {{- return(dbt_data_privacy._get_system_config(system_config_vars)) -}}
{% endmacro %}

{% macro _get_system_config(system_config_vars={}) %}
  {% set system_config = dbt_data_privacy.get_default_system_config() %}

  {% for k, v in system_config_vars %}
    {% if k in system_config %}
      system_config[k] = v
    {% endif %}
  {% endfor %}

  {{- return(system_config) -}}
{% endmacro %}

{% macro get_system_config_vars_block(dbt_vars={}) %}
  {% set system_config_vars = var('data_privacy', {}) %}
  {{ return(system_config_vars) }}
{% endmacro %}

{% macro get_default_system_config() %}
  {% set system_config = {
      "default_materialization": "view",
    } %}
  {{ return(system_config) }}
{% endmacro %}
