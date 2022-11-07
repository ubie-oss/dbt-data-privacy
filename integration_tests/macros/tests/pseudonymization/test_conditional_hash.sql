{% macro test_conditional_hash() %}
  {{- return(adapter.dispatch("test_conditional_hash", "dbt_data_privacy_integration_tests")()) -}}
{% endmacro %}

{% macro bigquery__test_conditional_hash() %}
  {% set expression = "column1" %}
  {% set default_method = "SHA256" %}
  {% set conditions = ["contains_pseudonymized_unique_identifiers"] %}

  {% set column_conditions = {"contains_pseudonymized_unique_identifiers": true} %}
  {% set result = dbt_data_privacy.conditional_hash(
        column_conditions=column_conditions,
        expression=expression,
        default_method=default_method,
        conditions=conditions,
        data_type=none) %}
  {% set expected = "column1" %}
  {{ assert_equals(result, expected) }}

  {% set result = dbt_data_privacy.conditional_hash(
        column_conditions=column_conditions,
        expression=expression,
        default_method=default_method,
        conditions=conditions,
        data_type="ARRAY") %}
  {% set expected = "column1" %}
  {{ assert_equals(result, expected) }}

  {% set column_conditions = {"contains_pseudonymized_unique_identifiers": false} %}
  {% set result = dbt_data_privacy.conditional_hash(
        column_conditions=column_conditions,
        expression=expression,
        default_method=default_method,
        conditions=conditions,
        data_type=none) %}
  {% set expected = "SHA256(CAST(column1 AS STRING))" %}
  {{ assert_equals(result, expected) }}

  {% set result = dbt_data_privacy.conditional_hash(
        column_conditions=column_conditions,
        expression=expression,
        default_method=default_method,
        conditions=conditions,
        data_type="ARRAY") %}
  {% set expected = "ARRAY(SELECT SHA256(CAST(e AS STRING)) FROM UNNEST(column1) AS e)" %}
  {{ assert_equals(result, expected) }}
{% endmacro %}
