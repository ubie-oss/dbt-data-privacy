{% macro is_macro_expression(expression) %}
  {#-
    Check if the expression seems to be a macro.
  -#}

  {% if expression is string and '(' in expression and ')' in expression %}
    {% do return(True) %}
  {% else %}
    {% do return(False) %}
  {% endif %}
{% endmacro %}
