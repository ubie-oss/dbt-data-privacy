{% macro test_generate_secured_model_schema_v2_data_tests() %}
  {{- return(adapter.dispatch("test_generate_secured_model_schema_v2_data_tests", "dbt_data_privacy_integration_tests")()) -}}
{% endmacro %}

{% macro default__test_generate_secured_model_schema_v2_data_tests() %}
  {%- set result = dbt_data_privacy.generate_secured_model_schema_v2(
      objective="data_analysis",
      name="test_project__test_dataset__test_table",
      database="test-project",
      schema="test_dataset",
      alias="test_table",
      description="Sample description",
      columns={
        "person_id": {
          "name": "person_id",
          "description": "Person ID",
          "config": {
            "meta": {
              "data_privacy": {
                "level": "confidential",
                "test_project__test_dataset__test_table": {
                  "data_tests": [
                    {
                      "relationships": {
                        "to": 'ref("test_project__test_dataset__users")',
                        "field": "id",
                      },
                    },
                  ],
                },
              },
            },
          },
        },
        "log_id": {
          "name": "log_id",
          "description": "Log ID",
          "config": {
            "meta": {
              "data_privacy": {
                "level": "internal",
                "test_project__test_dataset__test_table": {
                  "data_tests": [
                    {
                      "dbt_expectations.expect_column_proportion_of_unique_values_to_be_between": {
                        "min_value": 0.99,
                        "max_value": 1.0,
                        "row_condition": "DATE(event_time, 'Asia/Tokyo') = CURRENT_DATE('Asia/Tokyo') - 1",
                        "tags": ["only_prod"],
                      },
                    },
                  ],
                },
              },
            },
          },
        },
      },
      tags=["tag1"],
      labels={},
    ) -%}

  {%- set normalized_result = result | replace(' ', '') | trim -%}
  {%- if dbt_data_privacy.is_dbt_at_least('1.10.5') -%}
    {{ assert_str_in_value("'arguments':{'to':", normalized_result) }}
  {%- else -%}
    {{ assert_str_not_in_value("'arguments':{'to':", normalized_result) }}
    {{ assert_str_in_value("'relationships':{'to':", normalized_result) }}
  {%- endif -%}
  {{ assert_str_in_value("'field':'id'", normalized_result) }}
  {{ assert_str_in_value("'config':{'tags':['only_prod']}", normalized_result) }}
  {{ assert_str_in_value("'min_value':0.99", normalized_result) }}
  {{ assert_str_in_value("'row_condition':", normalized_result) }}
{% endmacro %}
