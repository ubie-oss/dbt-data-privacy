{% macro test_generate_privacy_protected_model_sql() %}
  {{- return(adapter.dispatch("test_generate_privacy_protected_model_sql", "dbt_data_privacy_integration_tests")()) -}}
{% endmacro %}

{% macro bigquery__test_generate_privacy_protected_model_sql() %}
  {%- set result = dbt_data_privacy.generate_privacy_protected_model_sql(
      config={
        "materialized": "view",
        "database": "data-analysis-project",
        "schema": "test_dataset",
        "alias": "test_privacy_protected_users",
        "grant_access_to": [
          {"project": "test-project1", "dataset": "test_dataset1"},
          {"project": "test-project2", "dataset": "test_dataset2"},
        ],
      },
      reference="ref('test_restricted_users')",
      columns={
        "id": {
          "meta": {
            "data_privacy": {
              "level": "public",
            },
          },
        },
        "user_id": {
          "meta": {
            "data_privacy": {
              "level": "confidential",
            },
          },
        },
      },
      where="1 = 1",
      relationships={
        "to": "ref('test_consents')",
        "fields": {"user_id": "user_id"},
        "where": "agree is TRUE",
      }
    ) -%}

  {%- set expected %}
{%- raw -%}
{{
  config(
    materialized="view",
    database="data-analysis-project",
    database="test_dataset",
    alias="test_privacy_protected_users",
    grant_access_to=[
      {"project": test-project1, "dataset": test_dataset1},
      {"project": test-project2, "dataset": test_dataset2},
      ],
    tags=[],
    labels={},

    persist_docs={'relation': True, 'columns': True},
    full_refresh=None,
    enabled=True
  )
}}

WITH privacy_protected_model AS (
  SELECT
        id AS `id`,
        TO_BASE64(SHA256(CAST(user_id AS STRING))) AS `user_id`,
  FROM
    ref('test_restricted_users')
  WHERE
    1 = 1
  )

SELECT
  source.*,
FROM privacy_protected_model AS source
JOIN {{ ref('test_consents') }} AS target
  ON source.user_id = target.user_id
  WHERE
  agree is TRUE
{%- endraw -%}
  {%- endset %}

  {% set result = result | replace(' ', '') | trim %}
  {% set expected = expected | replace(' ', '') | trim %}
  {{ assert_equals(result, expected) }}
{% endmacro %}
