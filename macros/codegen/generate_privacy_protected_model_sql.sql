{% macro generate_privacy_protected_model_sql(
    config,
    reference,
    columns,
    where=none,
    relationships=none
  ) %}
  {{- return(adapter.dispatch('generate_privacy_protected_model_sql', 'dbt_data_privacy')(
      config=config,
      reference=reference,
      columns=columns,
      where=where,
      relationships=relationships,
      **kwargs )) -}}
{% endmacro %}

{% macro bigquery__generate_privacy_protected_model_sql(
    config,
    reference,
    columns,
    where=none,
    relationships=none
  ) %}

  {% if columns | length == 0 %}
    {# TODO raise an error #}
  {% endif %}

  {# Extract model configurations #}
  {% set model_configurations = dbt_data_privacy.extract_model_configurations(**config) %}
  {% set enabled = model_configurations["enables"] | default(True, True) %}
  {% set full_refresh = model_configurations["full_refresh"] | default(none, True) %}
  {% set materialized = dbt_data_privacy.safe_quote(model_configurations["materialized"]) %}
  {% set database = dbt_data_privacy.safe_quote(model_configurations["database"]) %}
  {% set schema = dbt_data_privacy.safe_quote(model_configurations["schema"]) %}
  {% set alias = dbt_data_privacy.safe_quote(model_configurations["alias"]) %}
  {% set tags = model_configurations["tags"] | default([], True) %}
  {% set labels = model_configurations["labels"] | default({}, True) %}
  {% set persist_docs = model_configurations["persist_docs"] | default({}, True) %}
  {% set extra_configurations = model_configurations["extra_configurations"] %}

  {# Generate a model SQL #}
  {%- set model_sql %}
{{'{{'}}
  config(
    materialized={{- materialized -}},
    database={{- database -}},
    database={{- schema -}},
    alias={{- alias -}},
    {% if "grant_access_to" in model_configurations -%}
    grant_access_to=[
      {% for x in model_configurations["grant_access_to"] -%}
      {"project": {{ x.get("project") }}, "dataset": {{ x.get("dataset") }}},
      {% endfor -%}
    ],{%- endif %}
    tags={{ tags }},
    labels={{ labels }},
    {% for k, v in extra_configurations.items() -%}
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
  source.*,
FROM privacy_protected_model AS source
{% if relationships is not none and dbt_data_privacy.validate_relationships(relationships)  -%}
JOIN {{ '{{ ' ~ relationships["to"] ~ ' }}' }} AS target
  ON {% for k, v in relationships["fields"].items() -%}
    {%- if not loop.first -%}AND {% endif -%}
    source.{{ k }} = target.{{ v }}
  {% endfor -%}
{% if "where" in relationships and relationships["where"] | length > 0 -%}
WHERE
  {{ relationships["where"] }}
{%- endif %}
{%- endif %}
  {% endset %}

  {{- return(model_sql) -}}
{% endmacro %}
