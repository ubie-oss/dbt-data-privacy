{% macro generate_privacy_protected_model(node, extra_labels=none, legacy_schema=True) %}
  {% set generated_models = adapter.dispatch('generate_privacy_protected_model', 'dbt_data_privacy')(
      node,
      extra_labels=extra_labels,
      legacy_schema=legacy_schema) %}
  {{ return(generated_models) }}
{% endmacro %}

{% macro bigquery__generate_privacy_protected_model(node, extra_labels=none, legacy_schema=True) %}
  {% set ns = namespace(generated_models=[]) %}

  {% if dbt_data_privacy.has_data_privacy_meta(node) is false %}
    {{ log("Skip {}".format(node.unique_id), info=True) }}
  {% endif %}

  {% set resource_type = node.resource_type %}
  {% set reference = dbt_data_privacy.get_reference_from_node(node) %}
  {% set columns = node.get("columns") | default({}, True) %}

  {% set node_meta = dbt_data_privacy.get_column_meta_block(node) %}
  {% for data_privacy_meta in node_meta.data_privacy %}
    {% set name = data_privacy_meta.get("name") %}
    {% set objective = data_privacy_meta.get("objective") %}
    {% set model_config = data_privacy_meta.get("config") %}
    {% set relationships = data_privacy_meta.get("relationships") | default(none, True) %}
    {% set where = data_privacy_meta.get("where") | default(none, True) %}

    {% set data_privacy_config = dbt_data_privacy.get_data_privacy_config_by_objective(objective) %}
    {% set default_materialization = dbt_data_privacy.get_default_materialized_config(data_privacy_config) %}

    {% set model_config = dbt_data_privacy.format_model_config(**model_config) %}
    {% set enabled = model_config.get("enabled") %}
    {% set full_refresh = model_config.get("full_refresh", none) %}
    {% set materialized = model_config.get("materialized", default_materialization) %}
    {% set database = model_config.get("database") %}
    {% set schema = model_config.get("schema") %}
    {% set alias = model_config.get("alias") %}
    {% set tags = model_config.get("tags") %}
    {% set labels = model_config.get("labels") %}
    {% set persist_docs = model_config.get("persist_docs") %}
    {% set adapter_config = model_config.get("adapter_config") %}
    {% set unknown_config = model_config.get("unknown_config") %}

    {# Append the objective tag #}
    {% do tags.extend([dbt_data_privacy.get_default_tag(data_privacy_config), objective]) %}

    {# Add extra labels #}
    {%- if extra_labels is not none and extra_labels is mapping %}
      {% do labels.update(extra_labels) %}
    {%- endif %}

    {% set model_sql = dbt_data_privacy.generate_privacy_protected_model_sql(
        objective=objective,
        enabled=enabled,
        full_refresh=full_refresh,
        materialized=materialized,
        database=database,
        schema=schema,
        alias=alias,
        tags=tags,
        labels=labels,
        persist_docs=persist_docs,
        adapter_config=adapter_config,
        unknown_config=unknown_config,
        reference=reference,
        columns=columns,
        where=where,
        relationships=relationships
      ) %}

    {% if legacy_schema %}
      {% set schema_yaml = dbt_data_privacy.generate_secured_model_schema_v2_legacy(
          objective=objective,
          name=name,
          database=database,
          schema=schema,
          alias=alias,
          description=node.get("description"),
          columns=columns,
          tags=tags,
          labels=labels
        ) %}
    {% else %}
      {% set schema_yaml = dbt_data_privacy.generate_secured_model_schema_v2(
          objective=objective,
          name=name,
          database=database,
          schema=schema,
          alias=alias,
          description=node.get("description"),
          columns=columns,
          tags=tags,
          labels=labels
        ) %}
    {% endif %}

    {# NOTE: I tried to use the continue expression, but it doesn't work. #}
    {% if data_privacy_meta.enabled is not false %}
      {{ ns.generated_models.append({
          "name": name,
          "meta": data_privacy_meta,
          "model_sql": model_sql,
          "schema_yaml": schema_yaml,
         }) }}
    {% endif %}
  {% endfor %}

  {{ return(ns.generated_models) }}
{% endmacro %}
