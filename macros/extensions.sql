{% macro create_extensions() %}
{% set sql %}
    create extension if not exists ltree;
{% endset %}
{% do run_query(sql) %}
{% do log("Postgres extensions created.", info=True) %}
{% endmacro %}
