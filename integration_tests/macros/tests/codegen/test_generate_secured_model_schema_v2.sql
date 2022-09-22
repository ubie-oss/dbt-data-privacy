{% macro test_generate_secured_model_schema_v2() %}
  {{- return(adapter.dispatch("test_generate_secured_model_schema_v2", "dbt_data_privacy_integration_tests")()) -}}
{% endmacro %}

{% macro default__test_generate_secured_model_schema_v2() %}
  {%- set result = dbt_data_privacy.generate_secured_model_schema_v2(
      objective="data_analysis",
      name="test_project__test_dataset__test_table",
      database="test-project",
      schema="test_dataset",
      alias="test_table",
      description="Sample description",
      columns={
        "id": {
          "name": "id",
          "description": "Raw ID",
          "meta": {
            "data_privacy": {
              "level": "internal",
            },
          },
        },
        "user_id": {
          "name": "user_id",
          "description": "User ID",
          "meta": {
            "data_privacy": {
              "level": "confidential",
              "test_project__test_dataset__test_table": {
                "tests": [
                  "not_null"
                ],
              },
            },
          },
        },
        "consents.data_analysis": {
          "name": "consents.data_analysis",
          "description": "Agree on data analysis",
          "meta": {
            "data_privacy": {
              "level": "internal",
            },
          },
        },
        "consents.data_sharing": {
          "name": "consents.data_sharing",
          "description": "Agree on data sharing",
          "meta": {
            "data_privacy": {
              "level": "internal",
            },
          },
        },
      },
      tags=["tag1"],
      labels={
        "key1": "value1",
        "key2": "value2",
      }
    ) -%}

  {%- set expected %}
{%- raw -%}
---
# This was automatically generated by the `dbt-data-privacy` package.
version: 2

models:
  - name: test_project__test_dataset__test_table
    description: |
      Sample description
    tags: ['tag1']
    meta:
      key1: value1
      key2: value2
    tests:
      # The test enables us to show the schema YAML file to delete before re-generating the file.
      # A schema YAML file doesn't appear by `dbt ls --output path`, when it contains no tests.
      - dbt_data_privacy.dummy_test
    columns:
      - name: id
        description: |
          Raw ID
        meta:
          data_privacy:
            level: internal
      - name: user_id
        description: |
          User ID
        meta:
          data_privacy:
            level: internal
        tests:
          - not_null
      - name: consents.data_analysis
        description: |
          Agree on data analysis
        meta:
          data_privacy:
            level: internal
      - name: consents.data_sharing
        description: |
          Agree on data sharing
        meta:
          data_privacy:
            level: internal
{%- endraw -%}
  {%- endset %}

  {# for print-debug
    {% do print(result) %}
  #}

  {% set result = result | replace(' ', '') | trim %}
  {% set expected = expected | replace(' ', '') | trim %}
  {{ assert_equals(result, expected) }}
{% endmacro %}
