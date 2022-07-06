{% macro test_get_system_config() %}
  {{- return(adapter.dispatch("test_get_system_config", "dbt_data_privacy_integration_tests")()) -}}
{% endmacro %}

{% macro bigquery__test_get_system_config() %}

  {% set system_config_vars = get_test_empty_system_config_vars() %}
  {%- set result = dbt_data_privacy._get_system_config(system_config_vars=system_config_vars) -%}
  {{ assert_dict_equals(result, dbt_data_privacy.get_default_system_config()) }}

  {% set system_config_vars = get_test_custom_system_config_vars() %}
  {%- set result = dbt_data_privacy._get_system_config(system_config_vars=system_config_vars) -%}
  {% set default_materialization = result["default_materialization"] %}
  {{ assert_equals(default_materialization, "table") }}

{% endmacro %}


{% macro get_test_empty_system_config_vars() %}
{%- set empty_dbt_vars -%}
{%- raw -%}
---
data_privacy: {}
{%- endraw -%}
{%- endset -%}
{{ return(dbt_data_privacy.get_system_config_vars_block(fromyaml(empty_dbt_vars))) }}
{% endmacro %}

{% macro get_test_custom_system_config_vars() %}
{%- set custom_dbt_vars -%}
{%- raw -%}
---
data_privacy:
  default_materialization: "table"
{%- endraw -%}
{%- endset -%}
{{ return(dbt_data_privacy.get_system_config_vars_block(fromyaml(custom_dbt_vars))) }}
{% endmacro %}
