{# Dispatch family l_diversity_query_sql_impl: public SQL builder + BigQuery implementation. #}
{% macro l_diversity_test_query_sql(model, quasi_identifiers, sensitive_column, l, sample_limit) %}
  {{- dbt_data_privacy.l_diversity_validate_arguments(quasi_identifiers, sensitive_column, l, sample_limit) -}}
  {{ return(adapter.dispatch("l_diversity_query_sql_impl", "dbt_data_privacy")(model, quasi_identifiers, sensitive_column, l, sample_limit)) }}
{% endmacro %}

{% macro bigquery__l_diversity_query_sql_impl(model, quasi_identifiers, resolved_sensitive, l, sample_limit) %}
  {%- set l_int = l | int -%}
  {%- set sample_limit_int = sample_limit | int -%}
{# Distinct l-diversity: each distinct tuple of quasi_identifiers must have at least l distinct sensitive values. #}
WITH base AS (
  SELECT
    {% for col in quasi_identifiers -%}
    {{ col }},
    {%- endfor %}
    {{ resolved_sensitive }} AS _sensitive
  FROM {{ model }}
),
group_stats AS (
  SELECT
    {% for col in quasi_identifiers -%}
    {{ col }},
    {%- endfor %}
    COUNT(*) AS group_size,
    COUNT(DISTINCT _sensitive) AS distinct_sensitive_count
  FROM base
  GROUP BY {% for col in quasi_identifiers -%}{{ col }}{% if not loop.last %}, {% endif %}{%- endfor %}
),
violations AS (
  SELECT
    *,
    COUNT(*) OVER () AS total_violating_groups
  FROM group_stats
  WHERE distinct_sensitive_count < {{ l_int }}
)
SELECT *
FROM violations
QUALIFY ROW_NUMBER() OVER (
  ORDER BY
    distinct_sensitive_count ASC
    {% for col in quasi_identifiers -%}
    , {{ col }} ASC
    {%- endfor %}
) <= {{ sample_limit_int }}
{% endmacro %}
