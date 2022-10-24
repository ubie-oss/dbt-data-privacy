{% macro test_generate_privacy_protected_model_sql() %}
  {{- return(adapter.dispatch("test_generate_privacy_protected_model_sql", "dbt_data_privacy_integration_tests")()) -}}
{% endmacro %}

{% macro bigquery__test_generate_privacy_protected_model_sql() %}
  {% set model_config = dbt_data_privacy.format_model_config(
        materialized="view",
        database="data-analysis-project",
        schema="test_dataset",
        alias="test_privacy_protected_users",
        grant_access_to=[
          {"project": "test-project1", "dataset": "test_dataset1"},
          {"project": "test-project2", "dataset": "test_dataset2"},
        ],
        tags=["tag1"],
        labels={
          "key1": "value1",
          "key2": "value2",
        },
        require_partition_filter=true,
        partition_expiration_days=7
    ) %}
  {%- set result = dbt_data_privacy.generate_privacy_protected_model_sql(
      objective="data_analysis",
      materialized="view",
      database="data-analysis-project",
      schema="test_dataset",
      alias="test_privacy_protected_users",
      tags=["tag1"],
      labels={
        "key1": "value1",
        "key2": "value2",
      },
      adapter_config={
        "grant_access_to": [
          {"project": "test-project1", "dataset": "test_dataset1"},
          {"project": "test-project2", "dataset": "test_dataset2"},
        ],
        "partition_by": {
          "field": "created_at",
          "data_type": "timestamp",
          "granularity": "day"
        },
        "cluster_by": ["id"],
        "require_partition_filter": true,
        "partition_expiration_days": 7,
      },
      unknown_config={
        "re_data_monitored": true,
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
              "policy_tags": ["unique_identifier"],
            },
          },
        },
        "consents.data_analysis": {
          "meta": {
            "data_privacy": {
              "level": "internal",
            },
          },
        },
        "consents.data_sharing": {
          "meta": {
            "data_privacy": {
              "level": "internal",
            },
          },
        },
        "dummy_column": {
          "meta": {
            "data_privacy": {
              "level": "restricted",
            },
          },
        },
        "dummy_array": {
          "data_type": "ARRAY",
          "meta": {
            "data_privacy": {
              "level": "restricted",
            },
          },
        }
      },
      where="1 = 1",
      relationships={
        "to": "ref('test_consents')",
        "fields": {"user_id": "user_id"},
        "where": "agree is TRUE",
      }
    ) -%}

  {%- set expected -%}
{%- raw -%}
-- This was automatically generated by the `dbt-data-privacy` package.
{{
  config(
    materialized="view",
    database="data-analysis-project",
    schema="test_dataset",
    alias="test_privacy_protected_users",
    grant_access_to=[
      {
        "project": "test-project1",
        "dataset": "test_dataset1",
      },
      {
        "project": "test-project2",
        "dataset": "test_dataset2",
      },
    ],
    partition_by={
      "field": "created_at",
      "data_type": "timestamp",
      "granularity": "day",
    },
    cluster_by=['id'],
    tags=['tag1'],
    labels={
      "key1": "value1","key2": "value2",
    },
    re_data_monitored="True",
    persist_docs={'relation': True, 'columns': True},
    full_refresh=None,
    enabled=True
  )
}}

WITH privacy_protected_model AS (
  SELECT
    id AS `id`,
    SHA256(CAST(user_id AS STRING)) AS `user_id`,
    STRUCT(
      consents.data_analysis AS `data_analysis`,
      consents.data_sharing AS `data_sharing`
    ) AS `consents`,
    dummy_column AS `dummy_column`,
    dummy_array AS `dummy_array`,
  FROM
    {{ ref('test_restricted_users') }} AS __original_table
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

  {# for print-debug
    {% do print(result) %}
  #}

  {% set result = result | replace(' ', '') | trim %}
  {% set expected = expected | replace(' ', '') | trim %}
  {{ assert_equals(result, expected) }}
{% endmacro %}
