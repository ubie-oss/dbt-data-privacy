{% macro flatten_restructured_column_for_schema(restructured_column, path) %}
  {% if not (restructured_column.original_info is defined
      or restructured_column.additional_info is defined
      or restructured_column.fields is defined) %}
    {{ exceptions.raise_compiler_error("Invalid restructured_column {} in {}".format(restructured_column, path)) }}
  {% endif %}

  {{ return(adapter.dispatch("flatten_restructured_column_for_schema", "dbt_data_privacy")(
      restructured_column=restructured_column,
      path=path
    )) }}
{% endmacro %}

{% macro bigquery__flatten_restructured_column_for_schema(restructured_column, path) %}
  {% set flatten_columns = {} %}

  {% set is_array = false %}
  {% if restructured_column.original_info is defined
      and restructured_column.original_info.data_type is defined
      and restructured_column.original_info.data_type in ["ARRAY", "RECORD"] %}
    {% set is_array = true %}
  {% endif %}

  {% set is_struct = false %}
  {% if restructured_column.fields is defined
      and restructured_column.fields is sequence %}
    {% set is_struct = true %}
  {% endif %}

  {% if restructured_column.original_info is defined %}
    {# TODO overwrite downgraded data security level #}
    {% set full_column_name = path | join('.') %}
    {% set column_info = dbt_data_privacy.deep_copy_dict(restructured_column.original_info) %}

    {# overwrite by converted data security level #}
    {% set converted_level = dbt_data_privacy.get_converted_level_from_restructured_column(restructured_column) %}
    {% if column_info.meta is defined
            and column_info.meta.data_privacy is defined
            and column_info.meta.data_privacy.level is defined
            and converted_level is not none %}
       {% do column_info.meta.data_privacy.update({"level": converted_level}) %}
    {% endif %}

    {% set secured_expression = dbt_data_privacy.get_secured_expression_from_restructured_column(restructured_column) %}
    {% if secured_expression is not none %}
      {% do flatten_columns.update({full_column_name: column_info}) %}
    {% endif %}
  {% endif %}

  {% if restructured_column.fields is defined %}
    {% for sub_column_name, sub_restructured_column in restructured_column.fields.items() %}
      {% set sub_flatten_columns = dbt_data_privacy.flatten_restructured_column_for_schema(
          restructured_column=sub_restructured_column,
          path=(path + [sub_column_name])) %}
      {% for k, v in sub_flatten_columns.items() %}
        {% do flatten_columns.update({k: v}) %}
      {% endfor %}
    {% endfor %}
  {% endif %}

  {{ return(flatten_columns) }}
{% endmacro %}
