{% macro flatten_restructured_columns_for_schema(restructured_columns) %}
  {{ return(adapter.dispatch("flatten_restructured_columns_for_schema", "dbt_data_privacy")(
      restructured_columns=restructured_columns)) }}
{% endmacro %}

{% macro bigquery__flatten_restructured_columns_for_schema(restructured_columns) %}
  {% set flatten_columns = {} %}

  {# Iterate over keys to avoid collision with column named "items" #}
  {% for top_level_column_name in restructured_columns %}
    {% set top_level_restructured_column = restructured_columns[top_level_column_name] %}
    {% set sub_flatten_columns = dbt_data_privacy.flatten_restructured_column_for_schema(
      restructured_column=top_level_restructured_column, path=[top_level_column_name], aliased_path=[]) %}
    {% if sub_flatten_columns | length > 0 %}
      {% for sub_column_name in sub_flatten_columns %}
        {% set sub_column_info = sub_flatten_columns[sub_column_name] %}
        {% do flatten_columns.update({sub_column_name: sub_column_info}) %}
      {% endfor %}
    {% endif %}
  {% endfor %}

  {{ return(flatten_columns) }}
{% endmacro %}
