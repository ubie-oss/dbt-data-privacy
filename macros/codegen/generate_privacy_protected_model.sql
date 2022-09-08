{% macro generate_privacy_protected_model(node) %}
  {% set generated_models = adapter.dispatch('generate_privacy_protected_model', 'dbt_data_privacy')(node) %}
  {{ return(generated_models) }}
{% endmacro %}

{% macro bigquery__generate_privacy_protected_model(node) %}
  {% set generated_models = [] %}

  {% if dbt_data_privacy.has_data_privacy_meta(node) is false %}
    {{ log("Skip {}".format(node.unique_id), info=True) }}
  {% endif %}

  {% set resource_type = node.resource_type %}
  {% set reference = dbt_data_privacy.get_reference_from_node(node) %}
  {% set columns = node.get("columns") | default({}, True) %}

  {% for data_privacy_meta in node.meta.data_privacy %}
    {% set name = data_privacy_meta.get("name") %}
    {% set target_tag = data_privacy_meta.get("target_tag") %}
    {% set config = data_privacy_meta.get("config") %}
    {% set relationships = data_privacy_meta.get("relationships") | default(none, True) %}
    {% set where = data_privacy_meta.get("where") | default(none, True) %}

    {% set model_config = dbt_data_privacy.format_model_config(**config) %}
    {% set enabled = model_config["enabled"] %}
    {% set full_refresh = model_config["full_refresh"] %}
    {% set materialized = model_config["materialized"] %}
    {% set database = model_config["database"] %}
    {% set schema = model_config["schema"] %}
    {% set alias = model_config["alias"] %}
    {% set tags = model_config["tags"] %}
    {% set labels = model_config["labels"] %}
    {% set persist_docs = model_config["persist_docs"] %}
    {% set adapter_config = model_config["adapter_config"] %}
    {% set unknown_config = model_config["unknown_config"] %}

    {# Append the target tag #}
    {% do tags.append(target_tag) %}

    {% set model_sql = dbt_data_privacy.generate_privacy_protected_model_sql(
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

    {% set schema_yaml = dbt_data_privacy.generate_secured_model_schema_v2(
        name=name,
        database=database,
        schema=schema,
        alias=alias,
        description=node.get("description"),
        columns=columns,
        tags=tags,
        labels=labels,
      ) %}

    {# NOTE: I tried to use the continue expression, but it doesn't work. #}
    {% if data_privacy_meta.enabled is not false %}
      {{ generated_models.append({
          "name": name,
          "meta": data_privacy_meta,
          "model_sql": model_sql,
          "schema_yaml": schema_yaml,
         }) }}
    {% endif %}
  {% endfor %}

  {{ return(generated_models) }}
{% endmacro %}
