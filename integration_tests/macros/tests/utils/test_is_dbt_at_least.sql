{% macro test_is_dbt_at_least() %}
  {{- return(adapter.dispatch("test_is_dbt_at_least", "dbt_data_privacy_integration_tests")()) -}}
{% endmacro %}

{% macro default__test_is_dbt_at_least() %}
  {{ assert_true(dbt_data_privacy.parse_version_part('10rc1') == 10) }}
  {{ assert_false(dbt_data_privacy.is_version_at_least('1.10.4', '1.10.5')) }}
  {{ assert_true(dbt_data_privacy.is_version_at_least('1.10.5', '1.10.5')) }}
  {{ assert_true(dbt_data_privacy.is_version_at_least('1.10.5-rc1', '1.10.5')) }}
  {{ assert_true(dbt_data_privacy.is_version_at_least('1.11.0', '1.10.5')) }}
  {{ assert_true(dbt_data_privacy.is_version_at_least('2.0.0', '1.10.5')) }}
  {{ assert_false(dbt_data_privacy.is_version_at_least('1.10', '1.10.5')) }}
{% endmacro %}
