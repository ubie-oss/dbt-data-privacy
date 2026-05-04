{% macro l_diversity_validate_arguments(quasi_identifiers, resolved_sensitive, l, sample_limit) %}
  {# Required args and shape: list of string column names (not a single string). #}
  {%- if quasi_identifiers is none -%}
    {{ exceptions.raise_compiler_error("l_diversity: quasi_identifiers is required") }}
  {%- elif quasi_identifiers is string -%}
    {{ exceptions.raise_compiler_error("l_diversity: quasi_identifiers must be a non-empty list of column names") }}
  {%- elif quasi_identifiers | length == 0 -%}
    {{ exceptions.raise_compiler_error("l_diversity: quasi_identifiers must be a non-empty list of column names") }}
  {%- endif -%}

  {%- if resolved_sensitive is none or resolved_sensitive is not string or (resolved_sensitive | trim | length) == 0 -%}
    {{ exceptions.raise_compiler_error("l_diversity: resolved sensitive column name is missing or empty") }}
  {%- endif -%}
  {%- set resolved = resolved_sensitive | trim -%}

  {# Track seen names so GROUP BY semantics stay unambiguous. #}
  {%- set ns = namespace(uniq=[]) -%}
  {%- for col in quasi_identifiers -%}
    {%- if col is not string -%}
      {{ exceptions.raise_compiler_error("l_diversity: each quasi_identifier must be a string, got " ~ col) }}
    {%- endif -%}
    {%- if col in ns.uniq -%}
      {{ exceptions.raise_compiler_error("l_diversity: duplicate quasi_identifier '" ~ col ~ "'") }}
    {%- endif -%}
    {%- set _ = ns.uniq.append(col) -%}
  {%- endfor -%}

  {%- if resolved in ns.uniq -%}
    {{ exceptions.raise_compiler_error(
      "l_diversity: sensitive column '" ~ resolved ~ "' must not appear in quasi_identifiers"
    ) }}
  {%- endif -%}

  {# l: minimum COUNT(DISTINCT sensitive) per quasi-identifier tuple. #}
  {%- if l is none -%}
    {{ exceptions.raise_compiler_error("l_diversity: l is required") }}
  {%- endif -%}
  {%- set l_int = l | int -%}
  {%- if l_int < 1 -%}
    {{ exceptions.raise_compiler_error("l_diversity: l must be an integer >= 1") }}
  {%- endif -%}

  {# Cap rows returned when the test fails (avoids huge result sets). #}
  {%- set sample_limit_int = sample_limit | int -%}
  {%- if sample_limit_int < 1 -%}
    {{ exceptions.raise_compiler_error("l_diversity: sample_limit must be an integer >= 1") }}
  {%- endif -%}
{% endmacro %}
