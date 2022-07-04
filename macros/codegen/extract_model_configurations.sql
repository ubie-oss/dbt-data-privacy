{% macro extract_model_configurations(
    materialized,
    database,
    schema,
    alias,
    tags=[],
    labels={},
    persist_docs={"relation": true, "columns": true},
    full_refresh=none,
    enabled=true
  ) %}

  {% set configurations = {
      "materialized": materialized,
      "database": database,
      "schema": schema,
      "alias": alias,
      "tags": tags,
      "labels": labels,
      "persist_docs": persist_docs,
      "full_refresh": full_refresh,
      "enabled": enabled,
    } %}

  {# Merge adapter configurations #}
  {% set adapter_configurations = adapter.dispatch('extract_model_configurations', 'dbt_data_privacy')(**kwargs) %}
  {% do configurations.update(adapter_configurations) %}

  {{- return(configurations) -}}
{% endmacro %}

{% macro bigquery__extract_model_configurations(
    partition_by=none,
    cluster_by=none,
    require_partition_filter=none,
    grant_access_to=[]
  ) %}

  {% set adapter_configurations = {
      "partition_by": partition_by,
      "cluster_by": cluster_by,
      "require_partition_filter": require_partition_filter,
      "grant_access_to": grant_access_to,
      "extra_configurations": kwargs,
    } %}
  {{ return(adapter_configurations) }}
{% endmacro %}
