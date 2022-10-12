{% macro is_secure_method(method) %}
  {{ return(adapter.dispatch("is_secure_method", "dbt_data_privacy")(method)) }}
{% endmacro %}

{% macro bigquery__is_secure_method(method) %}
  {% set methods = {
      "RAW": false,
      "SHA256": true,
      "SHA512": true,
      "UDF_HASH": none,
      "CONDITIONAL_HASH": none,
      "DROPPED": true,
    }
  %}
  {% set capitalized_method = method | upper %}
  {% if capitalized_method not in methods %}
    {% do exceptions.raise_compiler_error("{} doesn't exit in {}".format(capitalized_method, methods)) %}
  {% endif %}

  {{ return(methods.get(capitalized_method) ) }}
{% endmacro %}
