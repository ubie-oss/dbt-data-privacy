{% macro get_test_data_handling_standards() %}
  {% set test_data_handling_standards = {
    'public': { 'method': 'RAW' },
    'internal': {'method': 'RAW'},
    'confidential': {'method': 'SHA256', 'converted_level': 'internal'},
    'restricted': {'method': 'DROPPED'}
  } %}
  {{ return(test_data_handling_standards) }}
{% endmacro %}
