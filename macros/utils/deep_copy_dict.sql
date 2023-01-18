{% macro deep_copy_dict(input_dict) %}
  {#
    The macro enables us to get a deeply copied dictionary, because it seems that Jinja2's 'copy'
    doesn't work with a deeply nested dictionary.
  #}
  {{ return(fromyaml(toyaml(input_dict))) }}
{% endmacro %}
