{% macro import_json(data, column_name="resource") %}
	SELECT '{{ data | replace("'", "''") }}'::JSON AS {{column_name}}
{% endmacro %}