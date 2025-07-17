{% macro get_data_privacy_objectives() %}
  {% set ns = namespace(targets=[]) %}

  {% set data_privacy_configs = dbt_data_privacy.get_data_privacy_configs() %}
  {% for target, v in data_privacy_configs.items() %}
    {% do ns.targets.append(target) %}
  {% endfor %}

  {{ return(ns.targets) }}
{% endmacro %}
