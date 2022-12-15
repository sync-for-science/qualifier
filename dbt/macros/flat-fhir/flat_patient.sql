{% macro flat_patient(table, column, is_jsonb) %}
	{{ return(adapter.dispatch('flat_patient')(table, column, is_jsonb)) }}
{% endmacro %}

{% macro postgres__flat_patient(table, column, is_jsonb) %}

{% set json_type = "jsonb" if is_jsonb else "json" %}

WITH fhir_flat AS (
	SELECT 
		p.{{column}} ->> 'id' AS id,
		(p.{{column}} ->> 'active')::BOOLEAN AS active,
		(p.{{column}} ->> 'birthDate') AS birth_date,
		CASE WHEN 
			p.{{column}} ->> 'deceasedBoolean' = 'true'
			OR p.{{column}} ->> 'deceasedDateTime' != ''	
		THEN true 
		WHEN p.{{column}} ->> 'deceasedBoolean' = 'false'
		THEN false 
		ELSE NULL END AS is_deceased,
		(p.{{column}} ->> 'deceasedDateTime') AS death_date,
		raceExtension.value -> 'valueCoding' ->> 'code' AS race_code,
		ethnicityExtension.value -> 'valueCoding' ->> 'code' AS ethnicity_code,
		-- currntly male, female or omitted (per Epic support)
		sexForClinicalUseCoding.value ->> 'code' AS clinical_sex,
		-- normalize on administrative gender values set
		CASE birthSexExtension.value ->> 'valueCode' 
			WHEN 'M' THEN 'male'
			WHEN 'F' THEN 'female'
			WHEN 'ASKU' THEN 'unknown'
			WHEN 'UNK' THEN 'unknown'
			WHEN 'OTH' THEN 'other'
		END AS birth_sex,
		p.{{column}} ->> 'gender' AS gender

	FROM {{table}} p
		LEFT JOIN {{json_type}}_array_elements(resource -> 'extension') AS birthSexExtension
			ON (birthSexExtension.value ->> 'url') =  'http://hl7.org/fhir/us/core/StructureDefinition/us-core-birthsex'

		LEFT JOIN {{json_type}}_array_elements(resource -> 'extension') AS sexForClinicalUseExtension
			ON (sexForClinicalUseExtension.value ->> 'url') =  'http://open.epic.com/FHIR/StructureDefinition/extension/sex-for-clinical-use'

		LEFT JOIN {{json_type}}_array_elements(sexForClinicalUseExtension -> 'valueCodeableConcept' -> 'coding') AS sexForClinicalUseCoding
			ON (sexForClinicalUseCoding.value ->> 'system') =  'urn:oid:1.2.840.114350.1.13.0.1.7.10.698084.130.657370.19999000'

		LEFT JOIN {{json_type}}_array_elements(resource -> 'extension') AS raceExtensionRoot
			ON (raceExtensionRoot.value ->> 'url') =  'http://hl7.org/fhir/us/core/StructureDefinition/us-core-race'

		LEFT JOIN {{json_type}}_array_elements(raceExtensionRoot -> 'extension') AS raceExtension
			ON (raceExtension.value ->> 'url') =  'http://hl7.org/fhir/us/core/StructureDefinition/us-core-race/ombCategory'
				OR (raceExtension.value ->> 'url') =  'ombCategory'

		LEFT JOIN {{json_type}}_array_elements(resource -> 'extension') AS ethnicityExtensionRoot
			ON (ethnicityExtensionRoot.value ->> 'url') = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-ethnicity'

		LEFT JOIN {{json_type}}_array_elements(ethnicityExtensionRoot -> 'extension') AS ethnicityExtension
			ON (ethnicityExtension.value ->> 'url') = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-ethnicity/ombCategory'
				OR  (ethnicityExtension.value ->> 'url') = 'ombCategory'
		ORDER BY race_code, ethnicity_code
),
fhir_agg AS (
	SELECT 
		id, 
		active, 
		is_deceased, 
		birth_date, 
		death_date, 
		gender,
		MAX(clinical_sex) AS clinical_sex, 
		MAX(birth_sex) AS birth_sex, 
		string_agg(race_code, ',') AS omb_race_code, 
		MAX(ethnicity_code) AS omb_ethnicity_code 
	FROM fhir_flat
	GROUP BY 1,2,3,4,5,6
)

SELECT 
	id, 
	active, 
	is_deceased, 
	birth_date, 
	death_date, 
	COALESCE(clinical_sex, birth_sex, gender) AS sex,
	omb_race_code, 
	omb_ethnicity_code
FROM fhir_agg

{% endmacro %}


{% macro duckdb__flat_patient(table, column, is_jsonb) %}

WITH fhir_struct AS (
	SELECT from_json({{column}}, '{
		"id":"VARCHAR",
		"birthDate": "VARCHAR",
		"active": "BOOLEAN",
		"deceasedDateTime": "VARCHAR",
		"deceasedBoolean": "VARCHAR",
		"gender": "VARCHAR",
		"extension":[{
			"url":"VARCHAR",
			"valueCode":"VARCHAR",
			"valueCodeableConcept": {
				"coding": [{
					"system":"VARCHAR","code":"VARCHAR","display":"VARCHAR"
				}]
			},
			"extension":[{
				"url":"VARCHAR",
				"valueCoding":{"system":"VARCHAR","code":"VARCHAR","display":"VARCHAR"},"valueString":"VARCHAR"
			}]
		}]
	}') AS resource
	FROM {{table}}
),
fhir_flat AS (
	SELECT
		resource.id,
		resource.active,
		resource.birthDate AS birth_date,
		CASE WHEN 
			resource.deceasedBoolean = true
			OR resource.deceasedDateTime != ''	
		THEN true 
		WHEN resource.deceasedBoolean = false
		THEN false 
		ELSE NULL END AS is_deceased,
		resource.deceasedDateTime AS death_date,
		resource.gender
	FROM fhir_struct
),
extensions_root AS (
	SELECT 
		resource.id AS id,
		UNNEST( resource.extension ) AS extensions,
	FROM
		fhir_struct
),
birth_sex_extension AS (
	SELECT
		id,
		CASE extensions.valueCode 
			WHEN 'M' THEN 'male'
			WHEN 'F' THEN 'female'
			WHEN 'ASKU' THEN 'unknown'
			WHEN 'UNK' THEN 'unknown'
			WHEN 'OTH' THEN 'other'
		END AS birth_sex,
	FROM extensions_root
	WHERE extensions.url =
		'http://hl7.org/fhir/us/core/StructureDefinition/us-core-birthsex'
),
extensions_children AS (
	SELECT
		id,
		UNNEST( extensions.extension ) AS child_extension,
		UNNEST( extensions.valueCodeableConcept.coding) AS extension_cc,
		extensions.url AS root_url
	FROM extensions_root
	WHERE extensions.url IN (
		'http://hl7.org/fhir/us/core/StructureDefinition/us-core-race',
		'http://hl7.org/fhir/us/core/StructureDefinition/us-core-ethnicity',
		'http://open.epic.com/FHIR/StructureDefinition/extension/sex-for-clinical-use'
	)
),
extensions_flat AS (
	SELECT
		id,
		CASE 
			WHEN root_url = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-race' AND (child_extension.url = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-race/ombCategory' OR child_extension.url = 'ombCategory')
			THEN child_extension.valueCoding.code
		END AS race_code,
		CASE 
			WHEN root_url = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-ethnicity' AND (child_extension.url = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-ethnicity/ombCategory' OR child_extension.url = 'ombCategory')
			THEN child_extension.valueCoding.code
		END AS ethnicity_code,
		CASE 
			WHEN root_url = 'http://open.epic.com/FHIR/StructureDefinition/extension/sex-for-clinical-use' AND extension_cc.system = 'urn:oid:1.2.840.114350.1.13.0.1.7.10.698084.130.657370.19999000'
			THEN extension_cc.code
		END AS sex_for_clincal_use
	FROM extensions_children
	ORDER BY race_code, ethnicity_code
),
extensions_agg AS (
	SELECT
		id,
		MAX(sex_for_clincal_use) AS sex_for_clincal_use,
		string_agg(race_code) AS omb_race_code,
		MAX(ethnicity_code) AS omb_ethnicity_code
	FROM
		extensions_flat
	GROUP BY 1
)


SELECT 	
	fhir_flat.id, 
	active, 
	is_deceased, 
	birth_date, 
	death_date, 
	COALESCE(sex_for_clincal_use, birth_sex, gender) AS sex,
	omb_race_code, 
	omb_ethnicity_code
FROM fhir_flat
	LEFT JOIN extensions_agg 
		ON extensions_agg.id = fhir_flat.id
	LEFT JOIN birth_sex_extension
		ON birth_sex_extension.id = fhir_flat.id 

{% endmacro %}
