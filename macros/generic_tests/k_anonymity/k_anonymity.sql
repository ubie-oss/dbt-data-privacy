{# Dispatch family test_k_anonymity: generic test + BigQuery implementation. #}
{% test k_anonymity(model, column_name=none, quasi_identifiers=none, k=none, sample_limit=50) %}
  {{ return(adapter.dispatch("test_k_anonymity", "dbt_data_privacy")(model, column_name, quasi_identifiers, k, sample_limit)) }}
{% endtest %}

{% macro bigquery__test_k_anonymity(model, column_name, quasi_identifiers, k, sample_limit) %}
  {{- dbt_data_privacy.k_anonymity_validate_arguments(quasi_identifiers, k, sample_limit) -}}
{%- if not execute -%}
  {{ return("") }}
{%- endif -%}
  {{ return(adapter.dispatch("k_anonymity_query_sql_impl", "dbt_data_privacy")(model, quasi_identifiers, k, sample_limit)) }}
{% endmacro %}
