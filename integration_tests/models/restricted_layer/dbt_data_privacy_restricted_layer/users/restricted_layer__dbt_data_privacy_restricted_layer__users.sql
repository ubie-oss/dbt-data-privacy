{% set database = var('restricted_layer') %}
{% set schema = "dbt_data_privacy_restricted_layer" %}

{{
  config(
    enabled=true,
    materialized="view",
    database=database,
    schema=schema,
    alias="users",
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

SELECT u.*
FROM {{ ref("restricted_layer__dbt_data_privacy_seed__users") }} AS u
