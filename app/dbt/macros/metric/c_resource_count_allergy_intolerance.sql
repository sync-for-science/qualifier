{% macro c_resource_count_allergy_intolerance(table='"allergyintolerance"', column="resource", is_jsonb=False, skip_date=False, skip_category=False) %}
	{{ return(adapter.dispatch('c_resource_count_allergy_intolerance')(table, column, is_jsonb, skip_date, skip_category)) }}
{% endmacro %}

{% macro postgres__c_resource_count_allergy_intolerance(table='"allergyintolerance"', column="resource", is_jsonb=False, skip_date=False, skip_category=False) %}

{% set json_type = "jsonb" if is_jsonb else "json" %}

WITH flat as (
	SELECT
		{{column}} ->> 'id' AS id,
		{{column}} ->> 'resourceType' AS resource_type,
		{% if skip_date %}
			NULL AS primary_date,
		{% else %}
			COALESCE(
				({{column}} ->> 'recordedDate'),
				({{column}} ->> 'onsetDateTime'),
				{{column}} -> 'onsetPeriod' ->> 'start'
			) AS primary_date,		
		{% endif %}
		{% if skip_category %}
			NULL AS category
		{% else %}
			category_code::TEXT AS category
		{% endif %}
	FROM {{table}}
	{% if skip_category == false %}
	LEFT JOIN {{json_type}}_array_elements_text({{column}} -> 'category') AS category_code ON true
	ORDER BY category_code
	{% endif %}
),
by_category AS (
	SELECT 
		id, 
		MAX(resource_type) AS resource_type, 
		MAX(primary_date) AS primary_date,
		string_agg(category, ',') AS category
	FROM flat
	GROUP BY 1
) 
SELECT 
	resource_type, 
	{% if skip_date %}
	NULL AS primary_year,
	NULL AS primary_month,
	{% else %}
	date_part('year', primary_date::DATE) AS primary_year,
	date_part('month', primary_date::DATE) AS primary_month,
	{% endif %}
	category,
	count(id) AS cnt
FROM by_category
GROUP BY 1,2,3,4

{% endmacro %}

{% macro duckdb__c_resource_count_allergy_intolerance(table='"allergyintolerance"', column="resource", is_jsonb=False, skip_date=False, skip_category=False) %}

WITH fhir_struct AS (
	SELECT from_json({{column}}, '{
		"id":"VARCHAR",
		"effectiveDateTime": "VARCHAR",
		"recordedDate": "VARCHAR",
		"onsetDateTime": "VARCHAR",
		"onsetPeriod": {"start": "VARCHAR"},
		"date": "VARCHAR",
		"authoredOn": "VARCHAR",
		"resourceType": "VARCHAR",
		"category": ["VARCHAR"]
	}') AS resource
	FROM {{table}}
)
SELECT 
	resource.resourceType AS resource_type,

	{% if skip_date %}
		NULL AS primary_year,
		NULL AS primary_month,
	{% else %}
		date_part('year', COALESCE(
			resource.recordedDate,
			resource.onsetDateTime,
			resource.onsetPeriod.start
		)::DATE) AS primary_year,
		date_part('month', COALESCE(
			resource.recordedDate,
			resource.onsetDateTime,
			resource.onsetPeriod.start
		)::DATE) AS primary_month,
	{% endif %}

	{% if skip_category %}
	NULL AS category,
	{% else %}
	list_string_agg(list_sort(resource.category)) AS category,
	{% endif %}

	count(resource.id) AS cnt

FROM fhir_struct
GROUP BY 1,2,3,4

{% endmacro %}