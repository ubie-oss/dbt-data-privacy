{% macro test_deep_copy_dict() %}
  {% set sub_dict2 = {"foo": "original"} %}
  {% set sub_dict1 = {"sub_dict2": sub_dict2} %}
  {% set input_dict1 = {"sub_dict1": sub_dict1 } %}

  {# Get a deeply copied dictionary #}
  {% set results = dbt_data_privacy.deep_copy_dict(input_dict1) %}
  {% set expected = {'sub_dict1': {'sub_dict2': {'foo': 'original'}}} %}
  {{ assert_dict_equals(results, expected) }}

  {# Change a value in the nested dictionary. The original dictionary should be updated. #}
  {% do sub_dict2.update({"foo": "updated"}) %}
  {% set expected = {'sub_dict1': {'sub_dict2': {'foo': 'updated'}}} %}
  {{ assert_dict_equals(input_dict1, expected) }}

  {# Meanwhile, the copied dictionary shouldn't be updated.'#}
  {% set expected = {'sub_dict1': {'sub_dict2': {'foo': 'original'}}} %}
  {{ assert_dict_equals(results, expected) }}
{% endmacro %}
