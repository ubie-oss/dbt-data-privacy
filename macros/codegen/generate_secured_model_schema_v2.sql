{% macro generate_secured_model_schema_v2(
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
      name,
      database,
      schema,
      alias,
      description=none,
      columns=[],
      tags=[],
      labels={}
    ) %}

  {%- set schema_yaml -%}
---
# This was automatically generated by the `dbt-data-privacy` package.
version: 2

models:
  - name: {{ name }}
    {% if description is not none -%}
    description: |
      {{ description }}
    {%- endif %}
    {% if tags | length > 0 -%}
    tags: {{ tags | unique | list }}
    {%- endif %}
    {% if labels | length > 0 -%}
    meta: {% for k, v in labels.items() %}
      {{ k }}: {{ v }}
    {%- endfor %}
    {%- endif %}

    {% if columns | length > 0 -%}
    columns: {%- for column_name, column in columns.items() %}
      - name: {{ column.name }}
        description: |
          {{ column.description | default('', true) }}
        {% if 'data_privacy' in column.meta and column.meta.data_privacy.level -%}
        meta:
          data_privacy:
            level: {{ column.meta.data_privacy.level }}
        {%- endif %}
        {% if 'data_privacy' in column.meta
            and name in column.meta.data_privacy
            and 'tests' in column.meta.data_privacy[name]
            and column.meta.data_privacy[name].tests | length > 0 -%}
        tests: {% for test in column.meta.data_privacy[name].tests %}
          - {{ test }}
        {%- endfor %}
        {%- endif %}
    {%- endfor %}
    {%- endif %}
  {% endset %}

  {% do return(schema_yaml) %}
{% endmacro %}
