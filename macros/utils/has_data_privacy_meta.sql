{% macro has_data_privacy_meta(node) %}
  {% if 'data_privacy' in node.meta
      and node.meta['data_privacy'] is iterable
      and node.meta['data_privacy'] | length > 0 %}
    {{- return(true) -}}
  {% endif %}
  {% do log("The name " ~ node.name ~ " doesn't have the 'data_privacy' meta.") %}
  {{- return(false) -}}
{% endmacro %}
