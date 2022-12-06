{% macro count_rows(query) %}
SELECT count(*) AS rows FROM ({{query}}) a
{% endmacro %}