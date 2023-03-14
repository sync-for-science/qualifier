{% macro c_resource_count_no_category(table='"observation"', column="resource", is_jsonb=False, resource_type="Observation", skip_date=False) %}
	{{ return(adapter.dispatch('c_resource_count_no_category')(table, column, is_jsonb, resource_type, skip_date)) }}
{% endmacro %}

{% macro postgres__c_resource_count_no_category(table, column, is_jsonb, resource_type, skip_date) %}

{% if resource_type == "Immunization" %}
	{% set date_element = "(" + column + " ->> 'occurrenceDateTime')::DATE" %}
{% elif resource_type == "Procedure"%}
	{% set date_element = 
		"COALESCE( " + column + " ->> 'performedDateTime', " + 
		column + " -> 'performedPeriod' ->> 'start')::DATE" 
	%}
{% elif resource_type == "MedicationAdministration" %}
	{% set date_element = "(" + column + " ->> 'effectiveDateTime')::DATE" %}
{% endif %}

SELECT
	{{column}} ->> 'resourceType' AS resource_type,
	{% if skip_date or not date_element %}
		NULL::INT AS primary_year,
		NULL::INT AS primary_month,
	{% else %}
		date_part('year', {{date_element}}) AS primary_year,
		date_part('month', {{date_element}}) AS primary_month,
	{% endif %}
	NULL AS category,
	COUNT(DISTINCT ({{column}} ->> 'id')) AS cnt
FROM {{table}}
GROUP BY 1,2,3,4
{% endmacro %}


{% macro duckdb__c_resource_count_no_category(table, column, is_jsonb, resource_type, skip_date) %}

{% if resource_type == "Immunization" %}
	{% set date_element = "resource.occurrenceDateTime::DATE" %}
{% elif resource_type == "Procedure"%}
	{% set date_element = "COALESCE(resource.performedDateTime, resource.performedPeriod.start)::DATE" %}
{% elif resource_type == "MedicationAdministration" %}
	{% set date_element = "resource.effectiveDateTime::DATE" %}
{% endif %}

WITH fhir_struct AS (
	SELECT from_json({{column}}, '{
		"id":"VARCHAR",
		"occurrenceDateTime": "VARCHAR",
		"effectiveDateTime": "VARCHAR",
		"performedDateTime": "VARCHAR",
		"performedPeriod": {"start": "VARCHAR"},
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
		date_part('year', {{date_element}}) AS primary_year,
		date_part('month', {{date_element}}) AS primary_month,
	{% endif %}
	NULL AS category,
	COUNT( DISTINCT resource.id ) AS cnt
FROM fhir_struct
GROUP BY 1,2,3,4

{% endmacro %}
