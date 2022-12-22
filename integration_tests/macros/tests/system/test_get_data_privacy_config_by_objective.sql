{% macro test_get_data_privacy_config_by_objective() %}
  {% set result = dbt_data_privacy.get_data_privacy_config_by_objective("data_analysis") %}
  {% set expected = {
     'default_materialization': 'view',
     'default_tag': 'dbt_data_privacy',
     "enabled_policy_tags": ["birthdate"],
     'data_handling_standards': {
       'public': { 'method': 'RAW' },
        'internal': {'method': 'RAW'},
        'confidential': {
          'method': 'SHA256',
          'converted_level': 'internal'
        },
        'restricted': {
          'converted_level': 'internal',
          'method': 'CONDITIONAL_HASH',
          'with': {
            'default_method': 'SHA256',
            'conditions': ['contains_pseudonymized_unique_identifiers']
          }
        },
        'highly_restricted': {'method': 'DROPPED'}
     }
   } %}

  {{ assert_dict_equals(result, expected) }}
{% endmacro %}
