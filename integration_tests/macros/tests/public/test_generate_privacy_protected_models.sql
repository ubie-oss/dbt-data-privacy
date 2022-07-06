{% macro test_generate_privacy_protected_models() %}
  {{- return(adapter.dispatch("test_generate_privacy_protected_models", "dbt_data_privacy_integration_tests")()) -}}
{% endmacro %}

{% macro bigquery__test_generate_privacy_protected_models() %}
  {% set generated_models = dbt_data_privacy.generate_privacy_protected_models(do_print=false) %}
  {{ assert_equals(generated_models | length, 4) }}
  {% for generated_model in generated_models %}
    {{ assert_element_in_list("name", generated_model) }}
    {{ assert_element_in_list("meta", generated_model) }}
    {{ assert_element_in_list("model_sql", generated_model) }}
    {{ assert_element_in_list("schema_yaml", generated_model) }}
  {% endfor %}
{% endmacro %}
