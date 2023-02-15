{% macro c_resource_count_no_category(table='"observation"', column="resource", is_jsonb=False, date_element="date", skip_date=False) %}
	{{ return(adapter.dispatch('c_resource_count_no_category')(table, column, is_jsonb, date_element, skip_date)) }}
{% endmacro %}

{% macro postgres__c_resource_count_no_category(table, column, is_jsonb, date_element, skip_date) %}
SELECT
	{{column}} ->> 'resourceType' AS resource_type,
	{% if skip_date %}
		NULL AS primary_year,
		NULL AS primary_month,
	{% else %}
		date_part('year', ({{column}} ->> '{{date_element}}')::DATE) AS primary_year,
		date_part('month', ({{column}} ->> '{{date_element}}')::DATE) AS primary_month,
	{% endif %}
	NULL AS category,
	COUNT(DISTINCT ({{column}} ->> 'id')) AS cnt
FROM {{table}}
GROUP BY 1,2,3,4
{% endmacro %}


{% macro duckdb__c_resource_count_no_category(table, column, is_jsonb, date_element, skip_date) %}
WITH fhir_struct AS (
	SELECT from_json({{column}}, '{
		"id":"VARCHAR",
		{% if date_element %}
		"{{date_element}}": "VARCHAR",
		{% endif %}
		"resourceType": "VARCHAR",
		"category": [{
			"coding": [{
				"system":"VARCHAR","code":"VARCHAR","display":"VARCHAR"
			}]
		}],
	}') AS resource
	FROM {{table}}
)
SELECT
	resource.resourceType AS resource_type,
	{% if skip_date or not date_element %}
		NULL AS primary_year,
		NULL AS primary_month,
	{% else %}
		date_part('year', resource.{{date_element}}::DATE) AS primary_year,
		date_part('month', resource.{{date_element}}::DATE) AS primary_month,
	{% endif %}
	NULL AS category,
	COUNT( DISTINCT resource.id ) AS cnt
FROM fhir_struct
GROUP BY 1,2,3,4

{% endmacro %}
