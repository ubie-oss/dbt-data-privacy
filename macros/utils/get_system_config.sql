{% macro get_system_config() %}
  {% set system_config_vars = dbt_data_privacy.get_system_config_vars_block() %}
  {{- return(dbt_data_privacy._get_system_config(system_config_vars)) -}}
{% endmacro %}

{% macro _get_system_config(system_config_vars={}) %}
  {% set system_config = dbt_data_privacy.get_default_system_config() %}

  {% for k, v in system_config_vars.items() %}
    {% if k in system_config %}
      {# Update the value of the key #}
      {% do system_config.update({k: v}) %}
    {% endif %}
  {% endfor %}

  {{- return(system_config) -}}
{% endmacro %}

{% macro get_system_config_vars_block(dbt_vars={}) %}
  {% set system_config_vars = dbt_vars.get("data_privacy") | default({}, true) %}
  {{ return(system_config_vars) }}
{% endmacro %}

{% macro get_default_system_config() %}
  {% set system_config = {
      "default_materialization": "view",
      "data_handling_standard": dbt_data_privacy.get_default_data_handling_standard(),
      "tag": dbt_data_privacy.get_default_attached_tag(),
    } %}
  {{ return(system_config) }}
{% endmacro %}

{% macro get_data_handling_standard() %}
  {% set system_config = dbt_data_privacy.get_system_config() %}
  {% if "data_handling_standard" not in system_config %}
    {{ exceptions.raise_compiler_error("data_handling_standard isn't set.") }}
  {% endif %}
  {{ return(system_config["data_handling_standard"]) }}
{% endmacro %}

{% macro get_default_data_handling_standard() %}
  {% set default_data_handling_standard = {
    'public': {
      'method': 'RAW',
      },
    'internal': {
     'method': 'RAW',
      },
    'confidential': {
      'method': 'SHA256',
      },
    'restricted': {
      'method': 'DROPPED',
      },
    } %}
  {{ return(default_data_handling_standard) }}
{% endmacro %}

{% macro get_data_handling_standard_definition(data_handling_standard, level) %}
  {% if level in data_handling_standard %}
    {# method #}
    {% if "method" not in data_handling_standard[level] %}
      {{ exceptions.raise_compiler_error("'method' isn't set in level {} of {}".format(level, data_handling_standard)) }}
    {% endif %}
    {% set method = data_handling_standard[level]["method"] %}

    {# with #}
    {% if "with" in data_handling_standard[level] %}
      {% set with = data_handling_standard[level]["with"] %}
    {% else %}
      {% set with = none %}
    {% endif %}

    {# converted_level #}
    {% if "converted_level" in data_handling_standard[level] %}
      {% set converted_level = data_handling_standard[level]["converted_level"] %}
    {% else %}
      {% set converted_level = none %}
    {% endif %}

    {{ return((method, with, converted_level)) }}
  {% else %}
    {{ exceptions.raise_compiler_error("No such level {} in {}".format(level, data_handling_standard)) }}
  {% endif %}
{% endmacro %}

{% macro get_attached_tag() %}
  {% set system_config = dbt_data_privacy.get_system_config() %}
  {{ return(system_config["tag"]) }}
{% endmacro %}

{% macro get_default_attached_tag() %}
  {% set attached_tag = "generated_by_dbt_data_privacy" %}
  {{ return(attached_tag) }}
{% endmacro %}
