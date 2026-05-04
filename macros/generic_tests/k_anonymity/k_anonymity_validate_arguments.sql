{% macro k_anonymity_validate_arguments(quasi_identifiers, k, sample_limit) %}
  {# Required args and shape: list of string column names (not a single string). #}
  {%- if quasi_identifiers is none -%}
    {{ exceptions.raise_compiler_error("k_anonymity: quasi_identifiers is required") }}
  {%- elif k is none -%}
    {{ exceptions.raise_compiler_error("k_anonymity: k is required") }}
  {%- elif quasi_identifiers is string -%}
    {{ exceptions.raise_compiler_error("k_anonymity: quasi_identifiers must be a non-empty list of column names") }}
  {%- elif quasi_identifiers | length == 0 -%}
    {{ exceptions.raise_compiler_error("k_anonymity: quasi_identifiers must be a non-empty list of column names") }}
  {%- endif -%}

  {# Track seen names so GROUP BY semantics stay unambiguous. #}
  {%- set ns = namespace(uniq=[]) -%}
  {%- for col in quasi_identifiers -%}
    {%- if col is not string -%}
      {{ exceptions.raise_compiler_error("k_anonymity: each quasi_identifier must be a string, got " ~ col) }}
    {%- endif -%}
    {%- if col in ns.uniq -%}
      {{ exceptions.raise_compiler_error("k_anonymity: duplicate quasi_identifier '" ~ col ~ "'") }}
    {%- endif -%}
    {%- set _ = ns.uniq.append(col) -%}
  {%- endfor -%}

  {# k: minimum row count per distinct quasi-identifier tuple. #}
  {%- set k_int = k | int -%}
  {%- if k_int < 1 -%}
    {{ exceptions.raise_compiler_error("k_anonymity: k must be an integer >= 1") }}
  {%- endif -%}

  {# Cap rows returned when the test fails (avoids huge result sets). #}
  {%- set sample_limit_int = sample_limit | int -%}
  {%- if sample_limit_int < 1 -%}
    {{ exceptions.raise_compiler_error("k_anonymity: sample_limit must be an integer >= 1") }}
  {%- endif -%}
{% endmacro %}
