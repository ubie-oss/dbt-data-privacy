{% macro is_securing_method(method) %}
  {{ return(adapter.dispatch("is_securing_method", "dbt_data_privacy")(method)) }}
{% endmacro %}

{% macro bigquery__is_securing_method(method) %}
  {% set methods = {
      "RAW": false,
      "SHA256": true,
      "SHA512": true,
      "CONDITIONAL_HASH": none,
      "DROPPED": true,
    }
  %}
  {% if method not in methods %}
    {% do exceptions.raise_compiler_error("{} doesn't exit in {}".format(method, methods)) %}
  {% endif %}

  {{ return(methods.get(method) ) }}
{% endmacro %}
