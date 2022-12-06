{% macro flat_obs_quantitative_component(table, column, is_jsonb) %}
	{{ return(adapter.dispatch('flat_obs_quantitative_component')(table, column, is_jsonb)) }}
{% endmacro %}

{% macro postgres__flat_obs_quantitative_component(table, column, is_jsonb) %}
SELECT 
	o.{{column}} ->> 'id' AS obs_id,
	o.{{column}} -> 'subject' ->> 'reference' AS subject,
	o.{{column}} ->> 'effectiveDateTime' AS effective_date_time,
	obs_coding.value ->> 'system' AS obs_system,
	obs_coding.value ->> 'code' AS obs_code,
	obs_coding.value ->> 'display' AS obs_display,
	obs_component_coding.value ->> 'code' AS code,
	obs_component_coding.value ->> 'system' AS system,
	obs_component_coding.value ->> 'display' AS display,
	CONCAT(o.resource ->> 'id', '-', obs_component.idx) AS id, 
	CASE
		WHEN (obs_component.value -> 'valueQuantity' ->> 'value') = ''
		THEN NULL 
		ELSE (obs_component.value -> 'valueQuantity' ->> 'value')::NUMERIC
	END AS quantity_value,
	obs_component.value -> 'valueQuantity' ->> 'system' AS quantity_system,
	obs_component.value -> 'valueQuantity' ->> 'code' AS quanitity_code,
	CASE 
		WHEN (obs_component.value ->> 'dataAbsentReason') != '' 
		THEN true 
		ELSE NULL 
	END AS has_data_absent
FROM {{ table }} o
	LEFT JOIN LATERAL {{ "jsonb_array_elements" if jsonb else "json_array_elements" }}({{column}} -> 'code' -> 'coding') obs_coding ON 1=1
	LEFT JOIN LATERAL {{ "jsonb_array_elements" if jsonb else "json_array_elements" }}({{column}} -> 'component')
		WITH ordinality AS obs_component(value, idx) ON 1=1
	LEFT JOIN LATERAL {{ "jsonb_array_elements" if jsonb else "json_array_elements" }}(obs_component.value -> 'code' -> 'coding') obs_component_coding ON 1=1
	WHERE 
		(obs_component.value -> 'valueQuantity' ->> 'value') IS NOT NULL 
		OR (obs_component.value ->> 'dataAbsentReason') IS NOT NULL 
{% endmacro %}

{% macro duckdb__flat_obs_quantitative_component(table, column, is_jsonb) %}

WITH fhir_struct AS (
	SELECT from_json({{ column }}, '{
		"id": "VARCHAR",
		"subject": {"reference": "VARCHAR"},
		"effectiveDateTime": "VARCHAR",
		"code": {
			"coding": [{
				"system":"VARCHAR","code":"VARCHAR","display":"VARCHAR"
			}]
		},
		"component": [{
			"code": {
				"coding": [{
					"system":"VARCHAR","code":"VARCHAR","display":"VARCHAR"
				}]
			},
      "valueQuantity": {
        "value": "VARCHAR",
        "system": "VARCHAR",
        "code": "VARCHAR"
      },
      "dataAbsentReason": "VARCHAR"
		}]
	}') AS resource
	FROM {{ table }}
),
flattened_coding AS (
	SELECT
		resource.id AS obs_id,
		resource.subject.reference AS subject,
		resource.effectiveDateTime AS effective_date_time,
		UNNEST(resource.code.coding) AS coding,
    resource.component AS component
	FROM fhir_struct
),
flattened_component AS (
  SELECT
    obs_id,
    subject,
    effective_date_time,
    coding,
	UNNEST(component) AS component  
  FROM
    flattened_coding
),
flattened_component_coding AS (
	SELECT 
		obs_id,
		subject,
		effective_date_time,
		coding.system AS obs_system,
		coding.code AS obs_code,
		coding.display AS obs_display,
		CASE
			WHEN component.valueQuantity.value = ''
			THEN NULL 
			ELSE component.valueQuantity.value::DOUBLE
		END AS quantity_value,
		component.valueQuantity.system AS quantity_system,
		component.valueQuantity.code AS quantity_code,
		CONCAT(
			obs_id, '-',
			row_number() over (PARTITION BY obs_id)
		) AS id, 
		CASE WHEN (component.dataAbsentReason) != '' 
			THEN true 
			ELSE NULL 
		END AS has_data_absent,
		UNNEST(component.code.coding) AS component_coding
	FROM flattened_component
		WHERE 
			component.valueQuantity.value IS NOT NULL
			OR has_data_absent 
)
SELECT
	obs_id,
	subject,
	effective_date_time,
	obs_system,
	obs_code,
	obs_display,
	component_coding.code AS code,
	component_coding.system AS system,
	component_coding.display AS display,
	id,
	quantity_value,
	quantity_system,
	quantity_code,
	has_data_absent

FROM flattened_component_coding

{% endmacro %}