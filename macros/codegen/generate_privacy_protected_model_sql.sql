{% macro generate_privacy_protected_model_sql() %}
  {{- return(adapter.dispatch('generate_privacy_protected_model_sql', 'dbt_data_privacy')(**kwargs)) -}}
{% endmacro %}

{% macro bigquery__generate_privacy_protected_model_sql(
    reference,
    materialized,
    database,
    schema,
    alias,
    columns=[],
    relationships=none,
    where=none,
    grant_access_to={},
    tags=[],
    labels={},
    persist_docs={"relation": true, "columns": true},
    partition_by=none,
    cluster_by=none,
    full_refresh=none,
    enabled=true
  ) %}

  {% if columns | length == 0 %}
    {# TODO raise an error #}
  {% endif %}

  {%- set model_sql %}
{{'{{'}}
  config(
    materialized={{- dbt_data_privacy.safe_quote(materialized) -}},
    database={{- dbt_data_privacy.safe_quote(database) -}},
    schema={{- dbt_data_privacy.safe_quote(schema) -}},
    alias={{- dbt_data_privacy.safe_quote(alias) -}},
    {% if grant_access_to -%}
    grant_access_to=[
      {% for x in grant_access_to -%}
      {"project": {{ x.get("project") }}, "dataset": {{ x.get("dataset") }}},
      {% endfor -%}
    ],{%- endif %}
    tags={{ tags }},
    labels={{ labels }},
    {% for k, v in kwargs.items() -%}
    {{ k -}}={{- dbt_data_privacy.safe_quote(v) -}},
    {%- endfor %}
    persist_docs={{ persist_docs }},
    full_refresh={{ full_refresh }},
    enabled={{ enabled }}
  )
{{'}}'}}

WITH privacy_protected_model AS (
  SELECT
    {%- for column_name, column_info in columns.items() -%}
      {%- if "data_privacy" in column_info.meta and column_info.meta.data_privacy.level %}
        {% set expression = dbt_data_privacy.get_secured_expression(column_name, column_info.meta.data_privacy.level) %}
        {%- if expression is not none -%}
          {{ expression }} AS `{{- column_name -}}`,
        {%- endif -%}
      {%- endif -%}
    {%- endfor %}
  FROM
    {% if dbt_data_privacy.is_macro_expression(reference) -%}
    {{ '{{ ' ~ reference ~ ' }}'}}
    {% else -%}
    {{ reference }}
    {%- endif %}
  {% if where is not none -%}
  WHERE
    {{ where }}
  {% endif -%}
)

SELECT
  s.*,
FROM privacy_protected_model AS s
{% if relationships is not none and dbt_data_privacy.validate_relationships(relationships)  -%}
JOIN {{ '{{ ' ~ relationships["to"] ~ ' }}' }} AS r
  ON {% for k, v in relationships["fields"].items() -%}
    {%- if not loop.first -%}AND {% endif -%}
    s.{{ k }} = r.{{ v }}
  {% endfor -%}
{%- endif %}
{% if "where" in relationships -%}
WHERE
  {{ relationships["where"] }}
{%- endif %}
  {% endset %}

  {{- return(model_sql) -}}
{% endmacro %}

{% macro validate_relationships(relationships) %}
  {% if 'to' not in relationships %}
    {% do exceptions.raise_compiler_error("Invalid relationships: 'to' doesn't exist in " ~ relationships) %}
  {% elif 'fields' not in relationships %}
    {% do exceptions.raise_compiler_error("Invalid relationships: 'fieldw' doesn't exist in " ~ relationships) %}
  {% elif relationships["fields"] is not mapping %}
    {% do exceptions.raise_compiler_error("Invalid relationships: 'fields' is not a dict" ~ relationships) %}
  {% endif %}
  {{ return(true) }}
{% endmacro %}
