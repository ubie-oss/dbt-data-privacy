{% macro drop_dataset() %}
  {% set dataset = target.dataset %}
  {% set drop_query %}
    DROP SCHEMA IF EXISTS `{{ target.project }}.{{ dataset }}` CASCADE
  {% endset %}
  {% do log("Dropping dataset: " ~ dataset, info=True) %}
  {% do run_query(drop_query) %}
{% endmacro %}
