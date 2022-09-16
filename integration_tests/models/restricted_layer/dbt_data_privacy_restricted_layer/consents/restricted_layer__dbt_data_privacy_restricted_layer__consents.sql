{% set database = var('restricted_layer') %}
{% set schema = "dbt_data_privacy_restricted_layer" %}
{% set data_privacy_config = dbt_data_privacy.get_data_privacy_config_by_target("data_analysis") %}
{% set data_handling_standards = data_privacy_config.get("data_handling_standards") %}

{{
  config(
    enabled=true,
    materialized="view",
    database=database,
    schema=schema,
    alias="consents",
    persist_docs={"relation": true, "columns": true},
    labels={
      "modeled_by": "dbt",
    },
    tags=[],
    grant_access_to=[
      {"project": var('restricted_layer'), "dataset": schema},
      {"project": var('restricted_layer'), "dataset": "dbt_data_privacy_seed"},
    ],
  )
}}

SELECT
  u.user_id AS `user_id`,
  {{ dbt_data_privacy.get_secured_expression_by_level(data_handling_standards, "u.user_id", "confidential") }} AS `pseudonymized_user_id`,
  STRUCT(
    data_analysis_consents.agree AS `data_analysis`,
    data_sharing_consents.agree AS `data_sharing`
  ) AS consent,
  [1, 2, 3] AS dummy_array,
FROM {{ ref("restricted_layer__dbt_data_privacy_seed__users") }} AS u
LEFT OUTER JOIN {{ ref("restricted_layer__dbt_data_privacy_seed__data_analysis_consents") }} AS data_analysis_consents
  ON u.user_id = data_analysis_consents.user_id
LEFT OUTER JOIN {{ ref("restricted_layer__dbt_data_privacy_seed__data_sharing_consents") }} AS data_sharing_consents
  ON u.user_id = data_sharing_consents.user_id
