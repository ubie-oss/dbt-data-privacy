-- This was automatically generated by the `dbt-data-privacy` package.
{{
  config(
    materialized="view",
    database=var('data_analysis_layer'),
    schema="dbt_data_privacy_data_analysis_layer",
    alias="orders",
    grant_access_to=[
      {
        "project": var('restricted_layer'),
        "dataset": "dbt_data_privacy_restricted_layer",
      },
    ],
    partition_by={
      "field": "created_at",
      "data_type": "timestamp",
      "granularity": "day",
    },
    cluster_by=['id'],
    tags=['data_analysis', 'dbt_data_privacy'],
    labels={
      "modeled_by": "dbt",
    },
    persist_docs={'relation': True, 'columns': True},
    full_refresh=None,
    enabled=True
  )
}}

WITH privacy_protected_model AS (
  SELECT
    id AS `id`,
    SHA256(CAST(user_id AS STRING)) AS `user_id`,
    item_id AS `item_id`,
    created_at AS `created_at`,
  FROM
    {{ ref('restricted_layer__dbt_data_privacy_restricted_layer__orders') }} AS __original_table
)
, __relationships_0 AS (
  SELECT *
  FROM {{ ref("data_analysis_layer__dbt_data_privacy_data_analysis_layer__users") }} AS __relationships_0
)

SELECT
  __source.*,
FROM privacy_protected_model AS __source
JOIN __relationships_0
  ON __source.user_id = __relationships_0.user_id
  
