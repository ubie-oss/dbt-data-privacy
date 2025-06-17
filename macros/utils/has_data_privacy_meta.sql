{% macro has_data_privacy_meta(node) %}
  {# Try new dbt 1.10+ format first (config.meta) #}
  {% if node.config is defined
      and node.config.meta is defined
      and 'data_privacy' in node.config.meta
      and node.config.meta['data_privacy'] is iterable
      and node.config.meta['data_privacy'] | length > 0 %}
    {{- return(true) -}}
  {% endif %}

  {# Fall back to old format (meta) for backward compatibility #}
  {% if node.meta is defined
      and 'data_privacy' in node.meta
      and node.meta['data_privacy'] is iterable
      and node.meta['data_privacy'] | length > 0 %}
    {{- return(true) -}}
  {% endif %}

  {% do log("The name " ~ node.name ~ " doesn't have the 'data_privacy' meta.") %}
  {{- return(false) -}}
{% endmacro %}
