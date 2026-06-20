{% macro test_format_data_test_for_schema_v2() %}
  {{- return(adapter.dispatch("test_format_data_test_for_schema_v2", "dbt_data_privacy_integration_tests")()) -}}
{% endmacro %}

{% macro default__test_format_data_test_for_schema_v2() %}
  {{ assert_equals(
      dbt_data_privacy.format_data_test_for_schema_v2('unique'),
      'unique'
    ) }}

  {{ assert_dict_equals(
      dbt_data_privacy._build_modern_data_test(
        'relationships',
        {},
        {
          'to': 'ref("foo")',
          'field': 'id',
        },
      ),
      {
        'relationships': {
          'arguments': {
            'to': 'ref("foo")',
            'field': 'id',
          },
        },
      }
    ) }}

  {{ assert_dict_equals(
      dbt_data_privacy._build_legacy_data_test(
        'relationships',
        {},
        {
          'to': 'ref("foo")',
          'field': 'id',
        },
      ),
      {
        'relationships': {
          'to': 'ref("foo")',
          'field': 'id',
        },
      }
    ) }}

  {{ assert_dict_equals(
      dbt_data_privacy._build_modern_data_test(
        'dbt_utils.expression_is_true',
        {},
        {
          'expression': ">= timestamp('2022-04-07 00:00:00', 'Asia/Tokyo')",
        },
      ),
      {
        'dbt_utils.expression_is_true': {
          'arguments': {
            'expression': ">= timestamp('2022-04-07 00:00:00', 'Asia/Tokyo')",
          },
        },
      }
    ) }}

  {{ assert_dict_equals(
      dbt_data_privacy._build_legacy_data_test(
        'dbt_utils.expression_is_true',
        {},
        {
          'expression': ">= timestamp('2022-04-07 00:00:00', 'Asia/Tokyo')",
        },
      ),
      {
        'dbt_utils.expression_is_true': {
          'expression': ">= timestamp('2022-04-07 00:00:00', 'Asia/Tokyo')",
        },
      }
    ) }}

  {{ assert_dict_equals(
      dbt_data_privacy._build_modern_data_test(
        'dbt_expectations.expect_column_proportion_of_unique_values_to_be_between',
        {'tags': ['only_prod']},
        {
          'min_value': 0.99,
          'max_value': 1.0,
          'row_condition': "DATE(event_time, 'Asia/Tokyo') = CURRENT_DATE('Asia/Tokyo') - 1",
        },
      ),
      {
        'dbt_expectations.expect_column_proportion_of_unique_values_to_be_between': {
          'config': {
            'tags': ['only_prod'],
          },
          'arguments': {
            'min_value': 0.99,
            'max_value': 1.0,
            'row_condition': "DATE(event_time, 'Asia/Tokyo') = CURRENT_DATE('Asia/Tokyo') - 1",
          },
        },
      }
    ) }}

  {{ assert_dict_equals(
      dbt_data_privacy._build_legacy_data_test(
        'dbt_expectations.expect_column_proportion_of_unique_values_to_be_between',
        {'tags': ['only_prod']},
        {
          'min_value': 0.99,
          'max_value': 1.0,
          'row_condition': "DATE(event_time, 'Asia/Tokyo') = CURRENT_DATE('Asia/Tokyo') - 1",
        },
      ),
      {
        'dbt_expectations.expect_column_proportion_of_unique_values_to_be_between': {
          'min_value': 0.99,
          'max_value': 1.0,
          'row_condition': "DATE(event_time, 'Asia/Tokyo') = CURRENT_DATE('Asia/Tokyo') - 1",
          'config': {
            'tags': ['only_prod'],
          },
        },
      }
    ) }}

  {{ assert_dict_equals(
      dbt_data_privacy._build_modern_data_test(
        'relationships',
        {'tags': ['only_prod']},
        {
          'to': 'ref("foo")',
          'field': 'id',
        },
      ),
      {
        'relationships': {
          'config': {
            'tags': ['only_prod'],
          },
          'arguments': {
            'to': 'ref("foo")',
            'field': 'id',
          },
        },
      }
    ) }}

  {{ assert_dict_equals(
      dbt_data_privacy._build_legacy_data_test(
        'relationships',
        {'tags': ['only_prod']},
        {
          'to': 'ref("foo")',
          'field': 'id',
        },
      ),
      {
        'relationships': {
          'to': 'ref("foo")',
          'field': 'id',
          'config': {
            'tags': ['only_prod'],
          },
        },
      }
    ) }}

  {{ assert_dict_equals(
      dbt_data_privacy._build_modern_data_test(
        'accepted_values',
        {'where': "order_date = current_date"},
        {'values': ['placed', 'shipped']},
        'unexpected_order_status_today',
      ),
      {
        'accepted_values': {
          'name': 'unexpected_order_status_today',
          'config': {
            'where': "order_date = current_date",
          },
          'arguments': {
            'values': ['placed', 'shipped'],
          },
        },
      }
    ) }}

  {{ assert_dict_equals(
      dbt_data_privacy.format_data_test_for_schema_v2({
        'relationships': {
          'to': 'ref("foo")',
          'field': 'id',
        },
      }),
      dbt_data_privacy._build_modern_data_test(
        'relationships',
        {},
        {
          'to': 'ref("foo")',
          'field': 'id',
        },
      ) if dbt_data_privacy.is_dbt_at_least('1.10.5') else dbt_data_privacy._build_legacy_data_test(
        'relationships',
        {},
        {
          'to': 'ref("foo")',
          'field': 'id',
        },
      )
    ) }}

  {{ assert_dict_equals(
      dbt_data_privacy.format_data_test_for_schema_v2({
        'relationships': {
          'arguments': {},
          'to': 'ref("foo")',
          'field': 'id',
        },
      }),
      dbt_data_privacy._build_modern_data_test(
        'relationships',
        {},
        {
          'to': 'ref("foo")',
          'field': 'id',
        },
      ) if dbt_data_privacy.is_dbt_at_least('1.10.5') else dbt_data_privacy._build_legacy_data_test(
        'relationships',
        {},
        {
          'to': 'ref("foo")',
          'field': 'id',
        },
      )
    ) }}

  {{ assert_dict_equals(
      dbt_data_privacy.format_data_test_for_schema_v2({
        'relationships': {
          'arguments': {
            'to': 'ref("foo")',
            'field': 'id',
          },
          'config': {
            'tags': ['only_prod'],
          },
        },
      }),
      dbt_data_privacy._build_modern_data_test(
        'relationships',
        {'tags': ['only_prod']},
        {
          'to': 'ref("foo")',
          'field': 'id',
        },
      ) if dbt_data_privacy.is_dbt_at_least('1.10.5') else dbt_data_privacy._build_legacy_data_test(
        'relationships',
        {'tags': ['only_prod']},
        {
          'to': 'ref("foo")',
          'field': 'id',
        },
      )
    ) }}

  {{ assert_dict_equals(
      dbt_data_privacy.format_data_test_for_schema_v2({
        'accepted_values': {
          'severity': 'warn',
          'values': ['placed', 'shipped'],
        },
      }),
      dbt_data_privacy._build_modern_data_test(
        'accepted_values',
        {'severity': 'warn'},
        {'values': ['placed', 'shipped']},
      ) if dbt_data_privacy.is_dbt_at_least('1.10.5') else dbt_data_privacy._build_legacy_data_test(
        'accepted_values',
        {'severity': 'warn'},
        {'values': ['placed', 'shipped']},
      )
    ) }}

  {{ assert_dict_equals(
      dbt_data_privacy.format_data_test_for_schema_v2({
        'accepted_values': {
          'name': 'unexpected_order_status_today',
          'values': ['placed', 'shipped'],
          'where': "order_date = current_date",
        },
      }),
      dbt_data_privacy._build_modern_data_test(
        'accepted_values',
        {'where': "order_date = current_date"},
        {'values': ['placed', 'shipped']},
        'unexpected_order_status_today',
      ) if dbt_data_privacy.is_dbt_at_least('1.10.5') else dbt_data_privacy._build_legacy_data_test(
        'accepted_values',
        {'where': "order_date = current_date"},
        {'values': ['placed', 'shipped']},
        'unexpected_order_status_today',
      )
    ) }}
{% endmacro %}
