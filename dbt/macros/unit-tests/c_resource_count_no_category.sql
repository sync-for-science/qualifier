{% macro test_c_resource_count_no_category_date()%}
WITH fhir AS (
	{{ import_json('{
		"id": "123",
		"resourceType": "Immunization",
		"occurenceDateTime": "2021-01-01"
	}' ) }}
),
result AS (
	{{ c_resource_count_no_category('fhir', 'resource', False, "occurenceDateTime") }}
),
expect AS (
	{% call table_to_sql() %}
   | resourcetype   |   primary_year |   primary_month | category   |   cnt |
   |----------------|----------------|-----------------|------------|-------|
   | 'Immunization' |           2021 |               1 | NULL       |     1 |
   	{% endcall %}
)

{{ compare_tables("expect", "result")}}
{% endmacro %}

{% macro test_c_resource_count_no_category_no_date()%}
WITH fhir AS (
	{{ import_json('{
		"id": "123",
		"resourceType": "Immunization"
	}' ) }}
),
result AS (
	{{ c_resource_count_no_category('fhir', 'resource', False, "occurenceDateTime") }}
),
expect AS (
	{% call table_to_sql() %}
   | resourceType   | primary_year::INT | primary_month::INT | category   |   cnt |
   |----------------|-------------------|--------------------|------------|-------|
   | 'Immunization' | NULL              | NULL               | NULL       |     1 |
   	{% endcall %}
)


{{ compare_tables("expect", "result")}}
{% endmacro %}

{% macro test_c_resource_count_no_category_skip_date()%}
WITH fhir AS (
	{{ import_json('{
		"id": "123",
		"resourceType": "Immunization",
		"occurenceDateTime": "2021-01-01"
	}' ) }}
),
result AS (
	{{ c_resource_count_no_category('fhir', 'resource', False, "occurenceDateTime", True) }}
),
expect AS (
	{% call table_to_sql() %}
   | resourceType   | primary_year   | primary_month   | category   |   cnt |
   |----------------|----------------|-----------------|------------|-------|
   | 'Immunization' | NULL           | NULL            | NULL       |     1 |
   	{% endcall %}
)

{{ compare_tables("expect", "result")}}
{% endmacro %}
