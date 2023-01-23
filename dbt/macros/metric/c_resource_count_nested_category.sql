{% macro c_resource_count_nested_category(table='"observation"', column="resource", is_jsonb=False, resource_type="Observation", skip_date=False, skip_category=False) %}
	{{ return(adapter.dispatch('c_resource_count_nested_category')(table, column, is_jsonb, resource_type, skip_date, skip_category)) }}
{% endmacro %}

{% macro postgres__c_resource_count_nested_category(table='"observation"', column="resource", is_jsonb=False, resource_type="Observation", skip_date=False, skip_category=False) %}

{% set json_type = "jsonb" if is_jsonb else "json" %}

WITH flat as (
	SELECT
		{{column}} ->> 'id' AS id,
		{{column}} ->> 'resourceType' AS resource_type,
		{% if skip_date %}
			NULL AS primary_date,
		{% elif resource_type == "Observation" %}
			({{column}} ->> 'effectiveDateTime') AS primary_date,
		{% elif resource_type == "DocumentReference" %}
			({{column}} ->> 'date') AS primary_date,
		{% elif resource_type == "MedicationRequest" %}
			({{column}} ->> 'authoredOn') AS primary_date,
		{% elif resource_type == "Encounter" %}
			({{column}} -> 'period' ->> 'start') AS primary_date,
		{% elif resource_type == "Condition" %}
			COALESCE(
				({{column}} ->> 'recordedDate'),
				({{column}} ->> 'onsetDateTime'),
				{{column}} -> 'onsetPeriod' ->> 'start'
			) AS primary_date,			
		{% else %}
			NULL AS primary_date,
		{% endif %}
		{% if skip_category %}
			NULL AS category
		{% elif resource_type == "Encounter" %}
			CONCAT(category_coding ->> 'system', '|', category_coding ->> 'code') AS category
		{% else %}
			category_coding ->> 'code' AS category
		{% endif %}
	FROM {{table}}
	{% if skip_category == false %}
		{% if resource_type == "Encounter" %}
		LEFT JOIN {{json_type}}_array_elements({{column}} -> 'type') AS category_cc ON true	
		{% else %}
		LEFT JOIN {{json_type}}_array_elements({{column}} -> 'category') AS category_cc ON true
		{% endif %}
	LEFT JOIN {{json_type}}_array_elements(category_cc.value -> 'coding') AS category_coding
	{% if resource_type == "DocumentReference" %}
		ON (category_coding ->> 'system') = 'http://hl7.org/fhir/us/core/CodeSystem/us-core-documentreference-category'
	{% elif resource_type == "Encounter" %}
		ON (category_coding ->> 'system') = 'http://www.ama-assn.org/go/cpt'
			OR (category_coding ->> 'system') = 'http://snomed.info/sct'
	{% else %}
		ON (category_coding ->> 'system') = 'http://terminology.hl7.org/CodeSystem/{{resource_type|lower}}-category'
	{% endif %}
	ORDER BY (category_coding ->> 'code')
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

{% macro duckdb__c_resource_count_nested_category(table='"observation"', column="resource", is_jsonb=False, resource_type="Observation", skip_date=False, skip_category=False) %}

WITH fhir_struct AS (
	SELECT from_json({{column}}, '{
		"id":"VARCHAR",
		"effectiveDateTime": "VARCHAR",
		"recordedDate": "VARCHAR",
		"onsetDateTime": "VARCHAR",
		"onsetPeriod": {"start": "VARCHAR"},
		"period": {"start": "VARCHAR"},
		"date": "VARCHAR",
		"type": [{
			"coding": [{
				"system":"VARCHAR","code":"VARCHAR","display":"VARCHAR"
			}]
		}],
		"authoredOn": "VARCHAR",
		"resourceType": "VARCHAR",
		"category": [{
			"coding": [{
				"system":"VARCHAR","code":"VARCHAR","display":"VARCHAR"
			}]
		}],
	}') AS resource
	FROM {{table}}
)
{% if skip_category == false %}
,
flattened_category_cc AS (
	SELECT
		resource.id,
		{% if resource_type == "Encounter" %}
		UNNEST(resource.type) AS category_cc
		{% else %}
		UNNEST(resource.category) AS category_cc
		{% endif %}
	FROM fhir_struct
),
flattened_category AS (
	SELECT
		id,
		UNNEST(category_cc.coding) AS codings
	FROM flattened_category_cc
),
ordered_category AS (
	SELECT
		id,
		{% if resource_type == "Encounter" %}
		CONCAT(codings.system, '|', codings.code) AS category, 
		{% else %}
		codings.code AS category,
		{% endif %}
	FROM flattened_category
	{% if resource_type == "DocumentReference" %}
		WHERE codings.system = 'http://hl7.org/fhir/us/core/CodeSystem/us-core-documentreference-category'
	{% elif resource_type == "Encounter" %}
		WHERE codings.system = 'http://www.ama-assn.org/go/cpt' OR codings.system = 'http://snomed.info/sct'
	{% else %}
		WHERE codings.system = 'http://terminology.hl7.org/CodeSystem/{{resource_type|lower}}-category'
	{% endif %}
	ORDER BY codings.code
),
grouped_category AS (
	SELECT id, 
	string_agg(category) AS category,
	FROM ordered_category
	GROUP BY 1
)
{% endif %}

SELECT 
	resource.resourceType AS resource_type,

	{% if skip_date %}
	NULL AS primary_year,
	NULL AS primary_month,
	{% elif resource_type == "Observation" %}
		date_part('year', resource.effectiveDateTime::DATE) AS primary_year,
		date_part('month', resource.effectiveDateTime::DATE) AS primary_month,
	{% elif resource_type == "DocumentReference" %}
		date_part('year', resource.date::DATE) AS primary_year,
		date_part('month', resource.date::DATE) AS primary_month,
	{% elif resource_type == "MedicationRequest" %}
		date_part('year', resource.authoredOn::DATE) AS primary_year,
		date_part('month', resource.authoredOn::DATE) AS primary_month,
	{% elif resource_type == "Encounter" %}
		date_part('year', resource.period.start::DATE) AS primary_year,
		date_part('month', resource.period.start::DATE) AS primary_month,
	{% elif resource_type == "Condition" %}
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
	{% else %}
		NULL AS primary_year,
		NULL AS primary_month,
	{% endif %}

	{% if skip_category %}
	NULL AS category,
	{% else %}
	category,
	{% endif %}

	count(resource.id) AS cnt

FROM fhir_struct
{% if skip_category == false %}
	LEFT JOIN grouped_category
		ON grouped_category.id = fhir_struct.resource.id
{% endif %}
GROUP BY 1,2,3,4

{% endmacro %}