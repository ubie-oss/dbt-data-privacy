-- This was automatically generated by the `dbt-data-privacy` package.
{{
  config(
    materialized="view",
    database=var('data_analysis_layer'),
    schema="dbt_data_privacy_data_analysis_layer",
    alias="consents",
    grant_access_to=[
      {
        "project": var('restricted_layer'),
        "dataset": "dbt_data_privacy_restricted_layer",
      },
    ],
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
    SHA256(CAST(user_id AS STRING)) AS `user_id`,
    STRUCT(
      consent.data_analysis AS `data_analysis`,
      SHA256(CAST(consent.data_sharing AS STRING)) AS `data_sharing`
    ) AS `consent`,
    ARRAY(SELECT SHA256(CAST(e AS STRING)) FROM UNNEST(dummy_array) AS e) AS `dummy_array`,
  FROM
    {{ ref('restricted_layer__dbt_data_privacy_restricted_layer__consents') }} AS __original_table
  WHERE
    consent.data_analysis IS TRUE
)

SELECT
  __source.*,
FROM privacy_protected_model AS __source
