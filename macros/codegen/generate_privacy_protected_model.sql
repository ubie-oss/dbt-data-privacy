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
    {% set config = data_privacy_meta.get("config") %}
    {% set relationships = data_privacy_meta.get("relationships") | default(none, True) %}
    {% set where = data_privacy_meta.get("where") | default(none, True) %}

    {% set model_sql = dbt_data_privacy.generate_privacy_protected_model_sql(
        config=config,
        reference=reference,
        columns=columns,
        where=where,
        relationships=relationships
      ) %}

    {% set schema_yaml = dbt_data_privacy.generate_secured_model_schema_v2(
        name=name,
        database=config.get("database"),
        schema=config.get("schema"),
        alias=config.get("alias"),
        description=node.get("description"),
        columns=columns,
        tags=config.get("tags"),
        labels=config.get("labels"),
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
