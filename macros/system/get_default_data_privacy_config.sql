{% macro get_default_data_privacy_config() %}
  {% set default_config = {
      "default_materialization": "view",
      "default_tag": "dbt_data_privacy",
    }
  %}
  {{ return(default_config) }}
{% endmacro %}
