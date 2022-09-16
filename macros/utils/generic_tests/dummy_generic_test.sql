{% test dummy_test(model) %}
  {#
    The test enables dbt to recognize generated schema YAML files.
    A schema YAML files don't appear with `dbt ls --output path`, if it contains no tests.
    To completely delete generated files, dbt-data-privacy automatically attaches `dummy_test`.
  #}

  {{ return(adapter.dispatch('test_dummy_test', 'dbt_data_privacy')(model)) }}
{% endtest %}

{% macro default__test_dummy_test(model, compare_model) %}
{#-- Prevent querying of db in parsing mode. This works because this macro does not create any new refs. #}
{%- if not execute -%}
    {{ return('') }}
{% endif %}

WITH dummy_data AS (
  SELECT 1 AS x
)
SELECT * FROM dummy_data WHERE x != 1
{% endmacro %}
