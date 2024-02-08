{% macro generate_secured_model_schema_v2(
      objective,
      name,
      database,
      schema,
      alias,
      description=none,
      columns={},
      tags=[],
      labels={}
    ) %}
  {{- return(adapter.dispatch('generate_secured_model_schema_v2', 'dbt_data_privacy')(
      objective=objective,
      name=name,
      database=database,
      schema=schema,
      alias=alias,
      description=description,
      columns=columns,
      tags=tags,
      labels=labels
    )) -}}
{% endmacro %}

{% macro default__generate_secured_model_schema_v2(
      objective,
      name,
      database,
      schema,
      alias,
      description=none,
      columns=[],
      tags=[],
      labels={}
    ) %}

  {% if columns | length == 0 %}
    {{ exceptions.raise_compiler_error("No columns for {}".format(name)) }}
  {% endif %}

  {%- set config = dbt_data_privacy.get_data_privacy_config_by_objective(objective) %}
  {%- set data_handling_standards = config.get('data_handling_standards') %}
  {%- set restructured_columns = dbt_data_privacy.get_secured_columns_v2(data_handling_standards, columns) %}
  {%- set flatten_columns = dbt_data_privacy.flatten_restructured_columns_for_schema(restructured_columns) %}

  {%- set schema_yaml -%}
---
# This was automatically generated by the `dbt-data-privacy` package.
version: 2

models:
  - name: {{ name }}
    {% if description is not none -%}
    description: |-
      {{ description | indent(width=6, first=False) }}
    {%- endif %}
    {%- if tags | length > 0 %}
    tags: {{ tags | unique | sort | list }}
    {%- endif %}
    {%- if labels | length > 0 %}
    meta: {%- for k, v in labels.items() %}
      {{ k }}: {{ v }}
    {%- endfor %}
    {%- endif %}

    {%- if columns | length > 0 %}
    columns: {%- for column_name, column in flatten_columns | dictsort %}
      - name: {{ column.name }}
        {%- if column.description is defined and column.description | length > 0 %}
        description: |-
          {{ column.description | default('', true) | indent(width=10, first=False) }}
        {%- endif %}
        {%- if 'data_privacy' in column.meta and column.meta.data_privacy.level %}
        {%- set data_privacy_level = column.meta.data_privacy.level %}
        meta:
          data_privacy:
            {#- Think of the downgraded data security level #}
            level: {{ column.meta.data_privacy.level }}
        {%- endif %}
        {%- if 'data_privacy' in column.meta
            and name in column.meta.data_privacy
            and 'tests' in column.meta.data_privacy[name]
            and column.meta.data_privacy[name].tests | length > 0 %}
        tests: {%- for test in column.meta.data_privacy[name].tests %}
          - {{ test }}
        {%- endfor %}
        {%- endif %}
    {%- endfor %}
    {%- endif %}
  {%- endset %}
  {% do return(schema_yaml) %}
{% endmacro %}
