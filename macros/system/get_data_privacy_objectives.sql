{% macro get_data_privacy_objectives() %}
  {% set ns = namespace(targets=[]) %}

  {% set data_privacy_configs = dbt_data_privacy.get_data_privacy_configs() %}
  {# Iterate over keys to avoid collision with key named "items" #}
  {% for target in data_privacy_configs %}
    {% do ns.targets.append(target) %}
  {% endfor %}

  {{ return(ns.targets) }}
{% endmacro %}
