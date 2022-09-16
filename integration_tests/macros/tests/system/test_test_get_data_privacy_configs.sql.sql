{% macro test_get_data_privacy_config_by_target() %}
  {% set result = dbt_data_privacy.get_data_privacy_config_by_target("data_analysis") %}
  {% set expected = {
     'default_materialization': 'view',
     'default_tag': 'dbt_data_privacy',
     'data_handling_standards': {
       'public': { 'method': 'RAW' },
        'internal': {'method': 'RAW'},
        'confidential': {'method': 'SHA256', 'converted_level': 'internal'},
        'restricted': {'method': 'DROPPED'}
     }
   } %}

  {{ assert_dict_equals(result, expected) }}
{% endmacro %}
