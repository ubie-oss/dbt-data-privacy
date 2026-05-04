{# Dispatch family k_anonymity_query_sql_impl: public SQL builder + BigQuery implementation. #}
{% macro k_anonymity_test_query_sql(model, quasi_identifiers, k, sample_limit) %}
  {{- dbt_data_privacy.k_anonymity_validate_arguments(quasi_identifiers, k, sample_limit) -}}
  {{ return(adapter.dispatch("k_anonymity_query_sql_impl", "dbt_data_privacy")(model, quasi_identifiers, k, sample_limit)) }}
{% endmacro %}

{% macro bigquery__k_anonymity_query_sql_impl(model, quasi_identifiers, k, sample_limit) %}
  {%- set k_int = k | int -%}
  {%- set sample_limit_int = sample_limit | int -%}
{# Exact k-anonymity: every distinct tuple of quasi_identifiers must appear on at least k rows. #}
WITH base AS (
  {# Project only the columns that define equivalence classes. #}
  SELECT
    {% for col in quasi_identifiers -%}
    {{ col }}{% if not loop.last %}, {% endif %}
    {%- endfor %}
  FROM {{ model }}
),
group_counts AS (
  {# One row per distinct tuple with its population count. #}
  SELECT
    {% for col in quasi_identifiers -%}
    {{ col }},
    {%- endfor %}
    COUNT(*) AS group_size
  FROM base
  GROUP BY {% for col in quasi_identifiers -%}{{ col }}{% if not loop.last %}, {% endif %}{%- endfor %}
),
violations AS (
  {# Tuples that violate k (too few rows); window exposes how many bad groups exist. #}
  SELECT
    *,
    COUNT(*) OVER () AS total_violating_groups
  FROM group_counts
  WHERE group_size < {{ k_int }}
)
{# On failure, return up to sample_limit rows (smallest groups first) for debugging. #}
SELECT *
FROM violations
QUALIFY ROW_NUMBER() OVER (
  ORDER BY
    group_size ASC
    {% for col in quasi_identifiers -%}
    , {{ col }} ASC
    {%- endfor %}
) <= {{ sample_limit_int }}
{% endmacro %}
