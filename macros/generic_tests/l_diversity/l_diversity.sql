{# Dispatch family test_l_diversity: generic test + BigQuery implementation. #}
{% test l_diversity(model, column_name=none, quasi_identifiers=none, sensitive_column=none, l=none, sample_limit=50) %}
  {{ return(adapter.dispatch("test_l_diversity", "dbt_data_privacy")(model, column_name, quasi_identifiers, sensitive_column, l, sample_limit)) }}
{% endtest %}

{% macro bigquery__test_l_diversity(model, column_name, quasi_identifiers, sensitive_column, l, sample_limit) %}
  {%- set resolved_sensitive = dbt_data_privacy.l_diversity_resolve_sensitive_column(sensitive_column, column_name) -%}
  {{- dbt_data_privacy.l_diversity_validate_arguments(quasi_identifiers, resolved_sensitive, l, sample_limit) -}}
{%- if not execute -%}
  {{ return("") }}
{%- endif -%}
  {{ return(adapter.dispatch("l_diversity_query_sql_impl", "dbt_data_privacy")(model, quasi_identifiers, resolved_sensitive, l, sample_limit)) }}
{% endmacro %}
