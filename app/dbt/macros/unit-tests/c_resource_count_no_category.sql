{% macro test_c_resource_count_no_category_date()%}
WITH fhir AS (
	{{ import_json('{
		"id": "123",
		"resourceType": "Immunization",
		"occurrenceDateTime": "2021-01-01"
	}' ) }}
),
result AS (
	{{ c_resource_count_no_category('fhir', 'resource', False, 'Immunization') }}
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
	{{ c_resource_count_no_category('fhir', 'resource', False, "Immunization") }}
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
		"occurrenceDateTime": "2021-01-01"
	}' ) }}
),
result AS (
	{{ c_resource_count_no_category('fhir', 'resource', False, 'Immunization', True) }}
),
expect AS (
	{% call table_to_sql() %}
   | resourceType   | primary_year::INT   | primary_month::INT   | category   |   cnt |
   |----------------|---------------------|----------------------|------------|-------|
   | 'Immunization' | NULL                | NULL                 | NULL       |     1 |
   	{% endcall %}
)

{{ compare_tables("expect", "result")}}
{% endmacro %}

{% macro test_c_resource_count_procedure_date_time()%}
WITH fhir AS (
	{{ import_json('{
		"id": "123",
		"resourceType": "Procedure",
		"performedDateTime": "2021-01-01"
	}' ) }}
),
result AS (
	{{ c_resource_count_no_category('fhir', 'resource', False, 'Procedure') }}
),
expect AS (
	{% call table_to_sql() %}
   | resourcetype   |   primary_year |   primary_month | category   |   cnt |
   |----------------|----------------|-----------------|------------|-------|
   | 'Procedure' |              2021 |               1 | NULL       |     1 |
   	{% endcall %}
)

{{ compare_tables("expect", "result")}}
{% endmacro %}

{% macro test_c_resource_count_procedure_period()%}
WITH fhir AS (
	{{ import_json('{
		"id": "123",
		"resourceType": "Procedure",
		"performedPeriod": {"start": "2021-01-01"}
	}' ) }}
),
result AS (
	{{ c_resource_count_no_category('fhir', 'resource', False, 'Procedure') }}
),
expect AS (
	{% call table_to_sql() %}
   | resourcetype   |   primary_year |   primary_month | category   |   cnt |
   |----------------|----------------|-----------------|------------|-------|
   | 'Procedure'    |           2021 |               1 | NULL       |     1 |
   	{% endcall %}
)

{{ compare_tables("expect", "result")}}
{% endmacro %}