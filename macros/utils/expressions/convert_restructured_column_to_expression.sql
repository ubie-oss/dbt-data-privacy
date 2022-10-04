{% macro convert_restructured_column_to_expression(key, restructured_column, depth=0, indent=true) %}
  {#
  {% if restructured_column.original_info is not defined
      or restructured_column.additional_info is not defined
      or restructured_column.fields is not defined %}
    {{ exceptions.raise_compiler_error("Invalid restructured_column {}".format(tojson(restructured_column))) }}
  {% endif %}
  #}

  {{ return(adapter.dispatch('convert_restructured_column_to_expression', 'dbt_data_privacy')(
    key=key,
    restructured_column=restructured_column,
    depth=depth,
    indent=indent)) }}
{% endmacro %}

{% macro bigquery__convert_restructured_column_to_expression(key, restructured_column, depth=0, indent=true) %}
  {% set is_array = false %}
  {% if restructured_column.original_info is defined
      and restructured_column.original_info.data_type is defined
      and restructured_column.original_info.data_type == "ARRAY" %}
    {% set is_array = true %}
  {% endif %}

  {% set is_struct = false %}
  {% if restructured_column.fields is defined
      and restructured_column.fields is mapping %}
    {% set is_struct = true %}
  {% endif %}

  {% set column_alias = restructured_column.additional_info.relative_path | join('.') %}

  {% set expression = none %}
  {% if is_array is sameas true and is_struct is sameas true %}
    {# ARRAY of STRUCT #}
    {%- set expression  -%}
ARRAY(
  SELECT
    STRUCT(
      {%- for sub_field_key, sub_field_info in restructured_column.fields.items() %}
      {{ dbt_data_privacy.convert_restructured_column_to_expression(sub_field_key, sub_field_info, depth=depth+1) }}{% if not loop.last %},{% endif %}
      {%- endfor %}
    )
  FROM UNNEST({{- column_alias -}})
) AS `{{- key -}}`
    {%- endset %}
  {% elif is_struct is sameas true %}
    {# STRUCT #}
    {%- set expression -%}
STRUCT(
  {%- for sub_field_key, sub_field_info in restructured_column.fields.items() %}
  {{ dbt_data_privacy.convert_restructured_column_to_expression(sub_field_key, sub_field_info, depth=depth+1) }}{% if not loop.last %},{% endif %}
  {%- endfor %}
) AS `{{- key -}}`
    {%- endset %}
  {% else %}
    {# scalar #}
    {% if restructured_column.additional_info.secured_expression is not defined %}
      {{ exceptions.raise_compiler_error("secured_expression is not defined {}".format(restructured_column)) }}
    {% endif %}

    {%- set expression -%}
    {{ restructured_column.additional_info.secured_expression }} AS `{{- key -}}`
    {%- endset %}
  {% endif %}

  {# indent by depth #}
  {% if indent is sameas true %}
    {% set expression = expression | indent(width=(2 * (depth+1)), first=false) %}
  {% endif %}
  {{ return(expression) }}
{% endmacro %}
