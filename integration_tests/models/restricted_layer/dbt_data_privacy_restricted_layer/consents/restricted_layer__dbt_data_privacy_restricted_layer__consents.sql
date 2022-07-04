{% set database = var('restricted_layer') %}
{% set schema = "dbt_data_privacy_restricted_layer" %}

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
  {{- dbt_data_privacy.get_secured_expression_by_data_security_level(
      "u.user_id", "confidential",  column_alias="pseudonymized_user_id") -}},
  data_analysis_consents.agree AS `data_analysis_agree`,
  data_sharing_consents.agree AS `data_sharing_agree`,
FROM {{ ref("restricted_layer__dbt_data_privacy_seed__users") }} AS u
LEFT OUTER JOIN {{ ref("restricted_layer__dbt_data_privacy_seed__data_analysis_consents") }} AS data_analysis_consents
  ON u.user_id = data_analysis_consents.user_id
LEFT OUTER JOIN {{ ref("restricted_layer__dbt_data_privacy_seed__data_sharing_consents") }} AS data_sharing_consents
  ON u.user_id = data_sharing_consents.user_id
