{% macro test_generate_privacy_protected_model_sql() %}
  {{- return(adapter.dispatch("test_generate_privacy_protected_model_sql", "dbt_data_privacy_integration_tests")()) -}}
{% endmacro %}

{% macro bigquery__test_generate_privacy_protected_model_sql() %}
  {%- set result = dbt_data_privacy.generate_privacy_protected_model_sql(
      grant_access_to=[
        {"project": "test-project1", "dataset": "test_dataset1"},
        {"project": "test-project2", "dataset": "test_dataset2"},
      ],
    ) -%}

  {%- set expected %}
{%- raw -%}
{{
  config(
    grant_access_to=[
      {"project": test-project1, "dataset": test_dataset1},
      {"project": test-project2, "dataset": test_dataset2},
      ]
  )
}}

SELECT 1
{%- endraw -%}
  {%- endset %}

  {% set result = result | trim %}
  {% set expected = expected | trim %}
  {{ assert_equals(result, expected) }}
{% endmacro %}
