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
      "adapter_config": {},
      "unknown_config": {},
    } %}

  {% if partition_by is not none %}
    {% do extra_config["adapter_config"].update({"partition_by": partition_by}) %}
  {% endif %}
  {% if cluster_by is not none %}
    {% do extra_config["adapter_config"].update({"cluster_by": cluster_by}) %}
  {% endif %}
  {% if require_partition_filter is not none %}
    {% do extra_config["adapter_config"].update({"require_partition_filter": require_partition_filter}) %}
  {% endif %}
  {% if partition_expiration_days is not none %}
    {% do extra_config["adapter_config"].update({"partition_expiration_days": partition_expiration_days}) %}
  {% endif %}
  {% if grant_access_to is not none %}
    {% do extra_config["adapter_config"].update({"grant_access_to": grant_access_to}) %}
  {% endif %}

  {% if kwargs is not none and kwargs is mapping %}
    {% do extra_config.update({"unknown_config": kwargs}) %}
  {% endif %}

  {{ return(extra_config) }}
{% endmacro %}
