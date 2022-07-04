{% macro is_macro_expression(expression) %}
  {#-
    Check if the expression seems to be a macro.
  -#}

  {% if '(' in text and ')' in text %}
    {% do return(true) %}
  {% else %}
    {% do return(false) %}
  {% endif %}
{% endmacro %}
