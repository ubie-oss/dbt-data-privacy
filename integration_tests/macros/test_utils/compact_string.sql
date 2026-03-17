{#
  This macro is used to compact a string by removing all spaces, newlines, and tabs.
  It is used to compare multiline strings in tests.
#}
{% macro compact_string(raw_string) %}
  {% set compacted_string = raw_string | replace(" ", "") | replace("\n", "") | replace("\t", "") | trim %}
  {% do return(compacted_string) %}
{% endmacro %}
