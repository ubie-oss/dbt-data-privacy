{% macro parse_version_part(part) %}
  {%- set clean_part = part.split('-')[0] -%}
  {%- set match = modules.re.match('^(\d+)', clean_part) -%}
  {%- if match is none -%}
    {%- do exceptions.raise_compiler_error(
        'dbt_data_privacy.parse_version_part: unable to parse version part "' ~ part ~ '"'
      ) -%}
  {%- endif -%}
  {{- return(match.group(1) | int) -}}
{% endmacro %}

{#-
  Pre-release suffixes (for example 1.10.5-rc1) are stripped before comparison,
  so release candidates at the same numeric version are treated as supported.
-#}
{% macro is_version_at_least(current_version, minimum_version) %}
  {%- set current_parts = current_version.split('.') -%}
  {%- set minimum_parts = minimum_version.split('.') -%}
  {%- set max_length = [current_parts | length, minimum_parts | length] | max -%}

  {%- for i in range(max_length) -%}
    {%- set current_part = 0 -%}
    {%- set minimum_part = 0 -%}
    {%- if i < current_parts | length -%}
      {%- set current_part = dbt_data_privacy.parse_version_part(current_parts[i]) -%}
    {%- endif -%}
    {%- if i < minimum_parts | length -%}
      {%- set minimum_part = dbt_data_privacy.parse_version_part(minimum_parts[i]) -%}
    {%- endif -%}
    {%- if current_part > minimum_part -%}
      {{- return(true) -}}
    {%- elif current_part < minimum_part -%}
      {{- return(false) -}}
    {%- endif -%}
  {%- endfor -%}
  {{- return(true) -}}
{% endmacro %}

{% macro is_dbt_at_least(minimum_version) %}
  {{- return(dbt_data_privacy.is_version_at_least(dbt_version, minimum_version)) -}}
{% endmacro %}
