{% macro has_data_privacy_meta(resource) %}
  {% if 'data_privacy' in resource.meta
      and resource.meta['data_privacy'] is list
      and resource.meta['data_privacy'] | length > 0 %}
    {{- return(true) -}}
  {% endif %}
  {% do log("The name " ~ resource.name ~ " doesn't have the 'data_privacy' meta.") %}
  {{- return(false) -}}
{% endmacro %}
