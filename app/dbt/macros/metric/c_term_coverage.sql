{% macro c_term_coverage(table='"observation"', column="resource", is_jsonb=False, resource_type="Observation", cc_element="code", skip_category=False) %}
	{{ return(adapter.dispatch('c_term_coverage')(table, column, is_jsonb, resource_type, cc_element, skip_category)) }}
{% endmacro %}

{% macro postgres__c_term_coverage(table='"observation"', column="resource", is_jsonb=False, resource_type="Observation", cc_element="code", skip_category=False) %}

{% set json_type = "jsonb" if is_jsonb else "json" %}
WITH system_detail AS (
	SELECT 
		{{column}} ->> 'id' AS id,
		coding ->> 'system' AS system,
		{% if skip_category %}
			'' AS category,
		{% else %}
			category_coding ->> 'code' AS category,
		{% endif %}
		{{column}} ->> 'resourceType' AS resource_type,
		{% if resource_type == 'encounter' and cc_element == 'type' %}
		CASE WHEN (types -> 'text') IS NOT NULL 
			THEN 1 ELSE 0
		END AS has_text		
		{% else %}
		CASE WHEN ({{column}} -> '{{cc_element}}' -> 'text') IS NOT NULL 
			THEN 1 ELSE 0
		END AS has_text
		{% endif %}
	FROM {{table}}
	{% if resource_type == 'encounter' and cc_element == 'type' %}
	LEFT JOIN {{json_type}}_array_elements({{column}} -> '{{cc_element}}') AS types ON true
	LEFT JOIN {{json_type}}_array_elements(types.value -> 'coding') AS coding ON true
	{% else %}
	LEFT JOIN {{json_type}}_array_elements({{column}} -> '{{cc_element}}' -> 'coding') AS coding ON true
	{% endif %}
	{% if skip_category == false %}
	LEFT JOIN {{json_type}}_array_elements({{column}} -> 'category') AS category_cc ON true
	LEFT JOIN {{json_type}}_array_elements(category_cc.value -> 'coding') AS category_coding
		ON (category_coding ->> 'system') = 'http://terminology.hl7.org/CodeSystem/condition-category'
			OR (category_coding ->> 'system') = 'http://terminology.hl7.org/CodeSystem/observation-category'
	{% endif %}
	GROUP BY 1,2,3,4,5
),
detail_agg AS (
	SELECT
		id,
		system,
		MAX(resource_type) AS resource_type,
		MIN(COALESCE(category, '')) AS category,
		MAX(has_text) AS has_text
	FROM system_detail
	GROUP BY 1,2
),
system_agg AS (
	SELECT
		id,	
		resource_type,
		category,
		has_text,
		STRING_AGG(system, ',' order by system) AS systems
	FROM detail_agg
	GROUP BY 1,2,3,4
),
resource_agg AS (
	SELECT
		COALESCE(category, '') AS category,
		COUNT(distinct id) AS cnt_total
	FROM system_detail
	GROUP BY 1
), result AS (
	SELECT
		resource_type,
		system_agg.category,
		'{{cc_element}}' AS element_name,
		resource_agg.cnt_total,
		CASE WHEN systems != '' THEN systems ELSE 'none' END AS systems,
		COUNT(id) AS cnt,
		SUM(has_text) AS cnt_text
	FROM system_agg
	LEFT JOIN resource_agg ON system_agg.category = resource_agg.category
	GROUP BY 1,2,3,4,5
	ORDER BY systems
)
SELECT * FROM result
{% endmacro %}

{% macro duckdb__c_term_coverage(table='"observation"', column="resource", is_jsonb=False, resource_type="Observation", cc_element="code", skip_category=False) %}
WITH fhir_struct AS (
	SELECT from_json({{column}}, '{
		"id":"VARCHAR",
		"resourceType": "VARCHAR",
		"category": [{
			"coding": [{
				"system":"VARCHAR", 
				"code": "VARCHAR"
			}]
		}],
		{% if resource_type == 'encounter' and cc_element == 'type' %}
		"type": [{
			"text": "VARCHAR",
			"coding": [{"system":"VARCHAR"}]
		}]
		{% else %}
		"{{cc_element}}": {
			"text": "VARCHAR",
			"coding": [{"system":"VARCHAR"}]
		}
		{% endif %}
	}') AS resource
	FROM {{table}}
),
{% if skip_category == false %}
flattened_category_cc AS (
	SELECT
		resource.id,
		UNNEST(resource.category) AS category_cc
	FROM fhir_struct
),
flattened_category AS (
	SELECT
		id,
		UNNEST(category_cc.coding) AS codings
	FROM flattened_category_cc
),
first_category AS (
	SELECT
		id,
		MIN(codings.code) AS category
	FROM flattened_category
		WHERE codings.system = 'http://terminology.hl7.org/CodeSystem/condition-category'
			OR codings.system = 'http://terminology.hl7.org/CodeSystem/observation-category'
	GROUP BY 1
),
resource_agg AS (
	SELECT
		COALESCE(category, '') AS category,
		COUNT(resource.id) AS cnt_total
	FROM fhir_struct
		LEFT JOIN first_category 
			ON first_category.id = resource.id
	GROUP BY 1
),
{% else %}
resource_agg AS (
	SELECT
		COUNT(resource.id) AS cnt_total
	FROM fhir_struct
),
{% endif %}
{% if resource_type == 'encounter' and cc_element == 'type' %}
flattened_types AS (
	SELECT 
		resource.id,
		UNNEST(resource.type) AS types
	FROM fhir_struct
),
flattened_code AS (
	SELECT 
		id,
		UNNEST(types.coding) AS codings
	FROM flattened_types
),
ordered_systems AS (
	SELECT 
		flattened_types.id,
		MAX(
			CASE WHEN types.text IS NOT NULL
			THEN 1 ELSE 0 END
		) AS has_text,
		codings.system AS system
	FROM flattened_types
		LEFT JOIN flattened_code ON flattened_types.id = flattened_code.id
	GROUP BY 1,3
),
{% else %}
flattened_code AS (
	SELECT 
		resource.id,
		UNNEST(resource['{{cc_element}}'].coding) AS codings
	FROM fhir_struct
),
ordered_systems AS (
	SELECT 
		resource.id,
		CASE 
			WHEN resource['{{cc_element}}'].text IS NOT NULL
			THEN 1 ELSE 0
		END AS has_text,
		codings.system AS system
	FROM fhir_struct 
		LEFT JOIN flattened_code ON fhir_struct.resource.id = flattened_code.id
	GROUP BY 1,2,3
),
{% endif %}
flattened_systems AS (
	SELECT 
		id,
		MAX(has_text) AS has_text,
		STRING_AGG(system, ',' order by system) AS systems
	FROM ordered_systems
	GROUP BY 1
)
SELECT
	resource.resourceType AS resource_type,
	{% if skip_category == false %}
	COALESCE(first_category.category, '') AS category,
	{% else %}
	'' AS category,
	{% endif %}
	'{{cc_element}}' AS element_name,
	MAX(cnt_total) AS cnt_total,
	COALESCE(flattened_systems.systems, 'none') AS systems,
	COUNT(resource.id) AS cnt,
	SUM(has_text) AS cnt_text
FROM fhir_struct
	{% if skip_category == false %}
	LEFT JOIN first_category ON first_category.id = fhir_struct.resource.id
	LEFT JOIN resource_agg ON COALESCE(first_category.category, '') = resource_agg.category
	{% else %}
	CROSS JOIN resource_agg
	{% endif %}
	LEFT JOIN flattened_systems ON flattened_systems.id = fhir_struct.resource.id
GROUP BY 1,2,3,5
ORDER BY systems
{% endmacro %}