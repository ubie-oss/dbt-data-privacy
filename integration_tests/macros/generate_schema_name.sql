{#
  This function overwrites the default `generate_schema_name`
  in order to eliminate `target_schema`, because the generated schema
  follows `<target_schema>_<custom_schema>`. In my opinion, the prefix
  is unnecessary for our case.

  SEE ALSO: https://docs.getdbt.com/docs/building-a-dbt-project/building-models/using-custom-schemas/#jinja-context-available-in-generate_schema_name
#}
{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- set default_schema = target.schema -%}
    {%- if custom_schema_name is none -%}

        {{ default_schema }}

    {%- else -%}

        {{ custom_schema_name | trim }}

    {%- endif -%}

{%- endmacro %}
