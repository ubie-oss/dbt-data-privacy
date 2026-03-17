{% macro drop_dataset() %}
  {% set dataset = target.schema %}
  {% set drop_query %}
    DROP SCHEMA IF EXISTS `{{ target.database }}.{{ dataset }}` CASCADE
  {% endset %}
  {% do log("Dropping dataset: " ~ dataset, info=True) %}
  {% do run_query(drop_query) %}
{% endmacro %}
