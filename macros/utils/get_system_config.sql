{% macro get_data_handling_standard_by_level(data_handling_standards, level) %}
  {% if level in data_handling_standards %}
    {# method #}
    {% if "method" not in data_handling_standards[level] %}
      {{ exceptions.raise_compiler_error("'method' isn't set in level {} of {}".format(level, data_handling_standards)) }}
    {% endif %}
    {% set method = data_handling_standards[level]["method"] %}

    {# with #}
    {% if "with" in data_handling_standards[level] %}
      {% set with = data_handling_standards[level]["with"] %}
    {% else %}
      {% set with = none %}
    {% endif %}

    {# converted_level #}
    {% if "converted_level" in data_handling_standards[level] %}
      {% set converted_level = data_handling_standards[level]["converted_level"] %}
    {% else %}
      {% set converted_level = none %}
    {% endif %}

    {{ return((method, with, converted_level)) }}
  {% else %}
    {{ exceptions.raise_compiler_error("No such level {} in {}".format(level, data_handling_standards)) }}
  {% endif %}
{% endmacro %}
