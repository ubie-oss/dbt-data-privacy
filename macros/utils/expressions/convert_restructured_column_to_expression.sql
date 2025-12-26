{% macro convert_restructured_column_to_expression(key, restructured_column, depth=0, indent=true, base_indent_width=4, indent_width_unit=2) %}
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
    indent=indent,
    base_indent_width=base_indent_width,
    indent_width_unit=indent_width_unit)) }}
{% endmacro %}

{% macro bigquery__convert_restructured_column_to_expression(key, restructured_column, depth=0, indent=true, base_indent_width=4, indent_width_unit=2) %}
  {% set is_array = false %}
  {% if restructured_column.original_info is defined
      and restructured_column.original_info.data_type is defined
      and restructured_column.original_info.data_type in ["ARRAY", "RECORD"] %}
    {% set is_array = true %}
  {% endif %}

  {% set is_struct = false %}
  {% if restructured_column.fields is defined
      and restructured_column.fields is mapping %}
    {% set is_struct = true %}
  {% endif %}

  {% set output_column_name = restructured_column.additional_info.alias | default(key) %}

  {% set column_alias = restructured_column.additional_info.relative_path | join('.') %}

  {% set expression = none %}
  {% if is_array is sameas true and is_struct is sameas true %}
    {# ARRAY of STRUCT #}
    {% set sub_expressions = [] %}
    {# Sort field keys alphabetically for deterministic ordering #}
    {% set sorted_field_keys = restructured_column.fields.keys() | list | sort %}
    {%- for sub_field_key in sorted_field_keys %}
      {%- set sub_field_info = restructured_column.fields[sub_field_key] %}
      {%- set expression = dbt_data_privacy.convert_restructured_column_to_expression(sub_field_key, sub_field_info, depth=depth+1) %}
      {%- if expression is not none %}
        {% do sub_expressions.append(expression) %}
      {%- endif %}
    {%- endfor %}

    {%- set expression -%}
ARRAY(
  SELECT
    STRUCT(
      {%- for sub_expression in sub_expressions %}
      {%- if sub_expression is not none %}
      {{ sub_expression }}{%- if not loop.last %},{%- endif %}
      {%- endif %}
      {%- endfor %}
    )
  FROM UNNEST({{- column_alias -}})
) AS `{{- output_column_name -}}`
    {%- endset %}
  {% elif is_struct is sameas true %}
    {# STRUCT #}
    {% set sub_expressions = [] %}
    {# Sort field keys alphabetically for deterministic ordering #}
    {% set sorted_field_keys = restructured_column.fields.keys() | list | sort %}
    {%- for sub_field_key in sorted_field_keys %}
      {%- set sub_field_info = restructured_column.fields[sub_field_key] %}
      {%- set expression = dbt_data_privacy.convert_restructured_column_to_expression(sub_field_key, sub_field_info, depth=depth+1) %}
      {%- if expression is not none %}
        {% do sub_expressions.append(expression) %}
      {%- endif %}
    {%- endfor %}

    {%- set expression -%}
STRUCT(
  {%- for sub_expression in sub_expressions %}
  {%- if sub_expression is not none %}
  {{ sub_expression }}{%- if not loop.last %},{%- endif %}
  {%- endif %}
  {%- endfor %}
) AS `{{- output_column_name -}}`
    {%- endset %}
  {% else %}
    {# scalar #}
    {% if not dbt_data_privacy.has_data_privacy_meta(restructured_column.original_info) %}
      {{ return(none) }}
    {% endif %}

    {% if restructured_column.additional_info.secured_expression is not defined %}
      {{ exceptions.raise_compiler_error("secured_expression is not defined {} => {}".format(key, restructured_column)) }}
    {% endif %}

    {% if restructured_column.additional_info.secured_expression is none  %}
      {{ return(none) }}
    {%- set expression -%}
    {%- endset %}
    {%- else %}
      {% set expression = '{} AS `{}`'.format(restructured_column.additional_info.secured_expression, output_column_name) %}
    {%- endif %}
  {% endif %}

  {# indent by depth #}
  {% if indent is sameas true %}
    {% set expression = expression | indent(width=(base_indent_width + indent_width_unit * depth), first=false) %}
  {% endif %}
  {{ return(expression) }}
{% endmacro %}
