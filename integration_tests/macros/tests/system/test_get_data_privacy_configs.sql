{% macro test_get_data_privacy_configs() %}
  {% set result = dbt_data_privacy.get_data_privacy_configs() %}
  {% set expected = {
      'data_analysis': {
        'default_materialization': 'view',
        'data_handling_standards': {
          'public': { 'method': 'RAW' },
          'internal': {'method': 'RAW'},
          'confidential': {'method': 'SHA256', 'converted_level': 'internal'},
          'restricted': {'method': 'DROPPED'}
        }
      }
   } %}

  {{ assert_dict_equals(result, expected) }}
{% endmacro %}
