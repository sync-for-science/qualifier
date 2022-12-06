{% macro flat_obs_quantitative(table, column, is_jsonb=True) %}
	{{ return(adapter.dispatch('flat_obs_quantitative')(table, column, is_jsonb)) }}
{% endmacro %}

{% macro postgres__flat_obs_quantitative(table, column, is_jsonb) %}
SELECT 
	o.{{column}} ->> 'id' AS id,
	o.{{column}} -> 'subject' ->> 'reference' AS subject,
	o.{{column}} ->> 'effectiveDateTime' AS effective_date_time,
	obs_coding.value ->> 'system' AS system,
	obs_coding.value ->> 'code' AS code,
	obs_coding.value ->> 'display' AS display,
	CASE
		WHEN (o.{{column}} -> 'valueQuantity' ->> 'value') = ''
		THEN NULL 
		ELSE (o.{{column}} -> 'valueQuantity' ->> 'value')::NUMERIC
	END AS quantity_value,
	o.{{column}} -> 'valueQuantity' ->> 'system' AS quantity_system,
	o.{{column}} -> 'valueQuantity' ->> 'code' AS quantity_code,
	CASE WHEN (o.{{column}} ->> 'dataAbsentReason') != '' THEN true ELSE NULL END AS has_data_absent
FROM {{ table }} o
	LEFT JOIN LATERAL {{ "jsonb_array_elements" if jsonb else "json_array_elements" }}({{column}} -> 'code' -> 'coding') obs_coding
		ON 1=1
	WHERE 
		(o.{{column}} -> 'valueQuantity' ->> 'value') IS NOT NULL 
		OR (o.{{column}} ->> 'dataAbsentReason') IS NOT NULL 
{% endmacro %}

{% macro duckdb__flat_obs_quantitative(table, column, is_jsonb) %}
WITH fhir_struct AS (
	SELECT from_json({{column}}, '{
		"id": "VARCHAR",
		"subject": {"reference": "VARCHAR"},
		"effectiveDateTime": "VARCHAR",
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
	}') AS resource
	FROM {{table}}
),
flattened_codes AS (
	SELECT 
		resource.id,
		resource.subject.reference AS subject,
		resource.effectiveDateTime AS effective_date_time,
		UNNEST(resource.code.coding) AS coding,
		CASE
			WHEN resource.valueQuantity.value = ''
			THEN NULL 
			ELSE resource.valueQuantity.value::NUMERIC
		END AS quantity_value,
		resource.valueQuantity.system AS quantity_system,
		resource.valueQuantity.code AS quantity_code,
		CASE WHEN (resource.dataAbsentReason) != '' 
			THEN true 
			ELSE NULL 
		END AS has_data_absent
	FROM fhir_struct
		WHERE 
			quantity_value IS NOT NULL
			OR has_data_absent 
)
SELECT 
	id,
	subject,
	effective_date_time,
	coding.system,
	coding.code,
	coding.display,
	quantity_value,
	quantity_system,
	quantity_code,
	has_data_absent
FROM
	flattened_codes

{% endmacro %}