{% macro format_model_config(
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

   {#- Append the default tags -#}
   {% set attached_tag = dbt_data_privacy.get_attached_tag() %}
   {% if tags is iterable %}
     {% do tags.append(attached_tag) %}
   {% else %}
     {% set tags = [attached_tag] %}
   {% endif %}

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
      "adapter_config": {},
      "unknown_config": {},
    } %}

  {# Merge adapter configurations #}
  {% set extra_config = adapter.dispatch('format_model_config', 'dbt_data_privacy')(**kwargs) %}
  {% do configurations.update(extra_config) %}

  {{- return(configurations) -}}
{% endmacro %}

{% macro bigquery__format_model_config(
    partition_by=none,
    cluster_by=none,
    require_partition_filter=none,
    partition_expiration_days=none,
    grant_access_to=none
  ) %}

  {% set extra_config = {
      "adapter_config": {
        "partition_by": partition_by,
        "cluster_by": cluster_by,
        "require_partition_filter": require_partition_filter,
        "partition_expiration_days": partition_expiration_days,
        "grant_access_to": grant_access_to,
      },
      "unknown_config": kwargs,
    } %}

  {{ return(extra_config) }}
{% endmacro %}
