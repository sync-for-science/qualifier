{% macro data_term_obs_weight_repeated_loinc() %}
{
	"resourceType": "Observation",
	"id": "example1",
	"category": [{
		"coding": [{
			"system": "http://terminology.hl7.org/CodeSystem/observation-category",
			"code": "vital-signs",
			"display": "Vital Signs"
		}],
		"text": "Vital Signs"
	}],
	"code": {
		"coding": [
			{
				"system": "urn:oid:1.2.840.114350.1.13.1.1.7.2.707679",
				"code": "14",
				"display": "Weight"
			},
			{
				"system": "http://open.epic.com/FHIR/StructureDefinition/observation-flowsheet-id",
				"code": "ttjlASTxfaxgiecvotrb78w0",
				"display": "Weight"
			},
			{
				"system": "http://loinc.org",
				"code": "29463-7",
				"display": "Body weight"
			},
			{
				"system": "http://loinc.org",
				"code": "3141-9",
				"display": "Body weight Measured"
			},
			{
				"system": "http://loinc.org",
				"code": "8716-3",
				"display": "Vital signs"
			}
		],
		"text": "Weight"
	}
}
{% endmacro %}

{% macro data_term_obs_weight_basic() %}
{
	"resourceType": "Observation",
	"id": "example2",
	"category": [{
		"coding": [{
			"system": "http://terminology.hl7.org/CodeSystem/observation-category",
			"code": "vital-signs",
			"display": "Vital Signs"
		}],
		"text": "Vital Signs"
	}],
	"code": {
		"coding": [{
			"system": "http://loinc.org",
			"code": "29463-7",
			"display": "Body weight"
		}],
		"text": "Weight"
	}
}
{% endmacro %}

{% macro data_term_obs_weight_basic_2() %}
{
	"resourceType": "Observation",
	"id": "example3",
	"category": [{
		"coding": [{
			"system": "http://terminology.hl7.org/CodeSystem/observation-category",
			"code": "vital-signs",
			"display": "Vital Signs"
		}],
		"text": "Vital Signs"
	}],
	"code": {
		"coding": [{
			"system": "http://loinc.org",
			"code": "29463-7",
			"display": "Body weight"
		}],
		"text": "Weight"
	}
}
{% endmacro %}

{% macro data_term_obs_weight_duplicate_categories() %}
{
	"resourceType": "Observation",
	"id": "example2",
	"category": [{
		"coding": [{
			"system": "http://terminology.hl7.org/CodeSystem/observation-category",
			"code": "vital-signs",
			"display": "Vital Signs"
		}],
		"text": "Vital Signs"
	},{
		"coding": [{
			"system": "http://terminology.hl7.org/CodeSystem/observation-category",
			"code": "vital-signs2",
			"display": "Vital Signs"
		}],
		"text": "Vital Signs"
	}],
	"code": {
		"coding": [{
			"system": "http://loinc.org",
			"code": "29463-7",
			"display": "Body weight"
		}],
		"text": "Weight"
	}
}
{% endmacro %}

{% macro data_term_obs_weight_missing_category() %}
{
	"resourceType": "Observation",
	"id": "example2",
	"code": {
		"coding": [{
			"system": "http://loinc.org",
			"code": "29463-7",
			"display": "Body weight"
		}],
		"text": "Weight"
	}
}
{% endmacro %}

{% macro data_term_obs_weight_no_text() %}
{
	"resourceType": "Observation",
	"id": "example2",
	"category": [{
		"coding": [{
			"system": "http://terminology.hl7.org/CodeSystem/observation-category",
			"code": "vital-signs",
			"display": "Vital Signs"
		}],
		"text": "Vital Signs"
	}],
	"code": {
		"coding": [{
			"system": "urn:oid:1.2.840.114350.1.13.1.1.7.2.707679",
			"code": "14",
			"display": "Weight"
		}]
	}
}
{% endmacro %}

{% macro data_term_obs_weight_only_text() %}
{
	"resourceType": "Observation",
	"id": "example2",
	"category": [{
		"coding": [{
			"system": "http://terminology.hl7.org/CodeSystem/observation-category",
			"code": "vital-signs",
			"display": "Vital Signs"
		}],
		"text": "Vital Signs"
	}],
	"code": { "text": "Weight" }
}
{% endmacro %}

{% macro data_term_obs_weight_missing_code() %}
{
	"resourceType": "Observation",
	"id": "example2",
	"category": [{
		"coding": [{
			"system": "http://terminology.hl7.org/CodeSystem/observation-category",
			"code": "vital-signs",
			"display": "Vital Signs"
		}],
		"text": "Vital Signs"
	}]
}
{% endmacro %}

{% macro data_term_immunization() %}
{
  "resourceType" : "Immunization",
  "id" : "imm-1",
  "status" : "completed",
  "vaccineCode" : {
    "coding" : [{
    	"system" : "http://hl7.org/fhir/sid/cvx",
        "code" : "158",
        "display" : "influenza, injectable, quadrivalent, contains preservative"
    },{
        "system" : "http://hl7.org/fhir/sid/ndc",
        "code" : "49281-0633-15",
        "display" : "FLUZONE QUADRIVALENT (Sanofi Pasteur Inc.)"
    }]
  },
  "occurrenceDateTime" : "2020-11-19T12:46:57-08:00",
  "primarySource" : false
}
{% endmacro %}

{% macro data_term_encounter() %}
{
	"resourceType": "Encounter",
	"id": "8863db67-d5dd-4490-98f8-875d309e3262",
	"status": "finished",
	"class": {
		"system": "http://terminology.hl7.org/CodeSystem/v3-ActCode",
		"code": "AMB"
	},
	"type": [
		{
			"coding": [
				{
					"system": "http://snomed.info/sct",
					"code": "424441002",
					"display": "Prenatal initial visit"
				}
			],
			"text": "Prenatal initial visit"
		}
	]
}

{% endmacro %}


{% macro test_c_term_coverage_common_system_combinations() %}
WITH fhir AS (
	{{ import_json( data_term_obs_weight_basic() ) }}
	UNION ALL
	{{ import_json( data_term_obs_weight_basic_2() ) }}
),
result AS (
	{{ c_term_coverage('fhir', 'resource', false) }}
),
expect AS (
	{% call table_to_sql() %}
   | resource_type   | category      | element_name   |   cnt_total | systems             |   cnt |   cnt_text |
   |-----------------|---------------|----------------|-------------|---------------------|-------|------------|
   | 'Observation'   | 'vital-signs' | 'code'         |           2 | 'http://loinc.org'  |     2 |          2 |
   	{% endcall %}
)

{{ compare_tables("expect", "result")}}

{% endmacro %}

{% macro test_c_term_coverage_distinct_system_combinations() %}
WITH fhir AS (
	{{ import_json( data_term_obs_weight_repeated_loinc() ) }}
	UNION ALL
	{{ import_json( data_term_obs_weight_basic_2() ) }}
),
result AS (
	{{ c_term_coverage('fhir') }}
),
expect AS (
	{% call table_to_sql() %}
   | resource_type   | category      | element_name   |   cnt_total | systems                                                                                                                              |   cnt |   cnt_text |
   |-----------------|---------------|----------------|-------------|--------------------------------------------------------------------------------------------------------------------------------------|-------|------------|
   | 'Observation'   | 'vital-signs' | 'code'         |           2 | 'http://loinc.org'                                                                                                                   |     1 |          1 |
   | 'Observation'   | 'vital-signs' | 'code'         |           2 | 'http://loinc.org,http://open.epic.com/FHIR/StructureDefinition/observation-flowsheet-id,urn:oid:1.2.840.114350.1.13.1.1.7.2.707679' |     1 |          1 |
   	{% endcall %}
)
{{ compare_tables("expect", "result")}}
{% endmacro %}

{% macro test_c_term_coverage_consolidate_repeated_systems() %}
WITH fhir AS (
	{{ import_json( data_term_obs_weight_repeated_loinc() ) }}
),
result AS (
	{{ c_term_coverage('fhir') }}
),
expect AS (
	{% call table_to_sql() %}
   | resource_type   | category      | element_name   |   cnt_total | systems                                                                                                                              |   cnt |   cnt_text |
   |-----------------|---------------|----------------|-------------|--------------------------------------------------------------------------------------------------------------------------------------|-------|------------|
   | 'Observation'   | 'vital-signs' | 'code'         |           1 | 'http://loinc.org,http://open.epic.com/FHIR/StructureDefinition/observation-flowsheet-id,urn:oid:1.2.840.114350.1.13.1.1.7.2.707679' |     1 |          1 |
   	{% endcall %}
)

{{ compare_tables("expect", "result")}}

{% endmacro %}

{% macro test_c_term_coverage_no_text() %}

WITH fhir AS (
	{{ import_json( data_term_obs_weight_no_text() ) }}
),
result AS (
	{{ c_term_coverage('fhir') }}
),
expect AS (
	{% call table_to_sql() %}
   | resource_type   | category      | element_name   |   cnt_total | systems                                      |   cnt |   cnt_text |
   |-----------------|---------------|----------------|-------------|----------------------------------------------|-------|------------|
   | 'Observation'   | 'vital-signs' | 'code'         |           1 | 'urn:oid:1.2.840.114350.1.13.1.1.7.2.707679' |     1 |          0 |
    {% endcall %}
)

{{ compare_tables("expect", "result")}}
{% endmacro %}

{% macro test_c_term_coverage_only_text() %}

WITH fhir AS (
	{{ import_json( data_term_obs_weight_only_text() ) }}
),
result AS (
	{{ c_term_coverage('fhir') }}
),
expect AS (
	{% call table_to_sql() %}
   | resource_type   | category      | element_name   |   cnt_total | systems                                      |   cnt |   cnt_text |
   |-----------------|---------------|----------------|-------------|----------------------------------------------|-------|------------|
   | 'Observation'   | 'vital-signs' | 'code'         |           1 | 'none'                                       |     1 |          1 |
    {% endcall %}
)

{{ compare_tables("expect", "result")}}
{% endmacro %}

{% macro test_c_term_coverage_skip_category() %}

WITH fhir AS (
	{{ import_json( data_term_obs_weight_no_text() ) }}
),
result AS (
	{{ c_term_coverage('fhir', 'resource', false, "Observation", "code", true) }}
),
expect AS (
	{% call table_to_sql() %}
   | resource_type   | category      | element_name   |   cnt_total | systems                                      |   cnt |   cnt_text |
   |-----------------|---------------|----------------|-------------|----------------------------------------------|-------|------------|
   | 'Observation'   | ''            | 'code'         |           1 | 'urn:oid:1.2.840.114350.1.13.1.1.7.2.707679' |     1 |          0 |
    {% endcall %}
)

{{ compare_tables("expect", "result")}}
{% endmacro %}

{% macro test_c_term_coverage_missing_code() %}

WITH fhir AS (
	{{ import_json( data_term_obs_weight_missing_code() ) }}
),
result AS (
	{{ c_term_coverage('fhir') }}
),
expect AS (
	{% call table_to_sql() %}
   | resource_type   | category      | element_name   |   cnt_total | systems   |   cnt |   cnt_text |
   |-----------------|---------------|----------------|-------------|-----------|-------|------------|
   | 'Observation'   | 'vital-signs' | 'code'         |           1 | 'none'    |     1 |          0 |
    {% endcall %}
)

{{ compare_tables("expect", "result")}}
{% endmacro %}

{% macro test_c_term_coverage_ignore_duplicate_categories() %}
WITH fhir AS (
	{{ import_json( data_term_obs_weight_duplicate_categories() ) }}
),
result AS (
	{{ c_term_coverage('fhir') }}
),
expect AS (
	{% call table_to_sql() %}
   | resource_type   | category      | element_name   |   cnt_total | systems   |   cnt |   cnt_text |
   |-----------------|---------------|----------------|-------------|-----------|-------|------------|
   | 'Observation'   | 'vital-signs' | 'code'         |           1 | 'http://loinc.org' |     1 |          1 |
    {% endcall %}
)

{{ compare_tables("expect", "result")}}
{% endmacro %}

{% macro test_c_term_coverage_missing_category() %}
WITH fhir AS (
	{{ import_json( data_term_obs_weight_missing_category() ) }}
),
result AS (
	{{ c_term_coverage('fhir') }}
),
expect AS (
	{% call table_to_sql() %}
   | resource_type   | category      | element_name   |   cnt_total | systems   |   cnt |   cnt_text |
   |-----------------|---------------|----------------|-------------|-----------|-------|------------|
   | 'Observation'   | ''            | 'code'         |           1 | 'http://loinc.org' |     1 |          1 |
    {% endcall %}
)

{{ compare_tables("expect", "result")}}

{% endmacro %}

{% macro test_c_term_coverage_non_code_element_name() %}

WITH fhir AS (
	{{ import_json( data_term_immunization() ) }}
),
result AS (
	{{ c_term_coverage('fhir', 'resource', false, "Immunization", "vaccineCode", true) }}
),
expect AS (
	{% call table_to_sql() %}
   | resource_type   | category   | element_name   |   cnt_total | systems                                                   |   cnt |   cnt_text |
   |-----------------|------------|----------------|-------------|-----------------------------------------------------------|-------|------------|
   | 'Immunization'  | ''         | 'vaccineCode'  |           1 | 'http://hl7.org/fhir/sid/cvx,http://hl7.org/fhir/sid/ndc' |     1 |          0 |
   {% endcall %}
)

{{ compare_tables("expect", "result")}}

{% endmacro %}


{% macro test_c_term_coverage_encounter() %}

WITH fhir AS (
	{{ import_json( data_term_encounter() ) }}
),
result AS (
	{{ c_term_coverage('fhir', 'resource', false, "encounter", "type", true) }}
),
expect AS (
	{% call table_to_sql() %}
   | resource_type   | category   | element_name   |   cnt_total | systems                                                   |   cnt |   cnt_text |
   |-----------------|------------|----------------|-------------|-----------------------------------------------------------|-------|------------|
   | 'Encounter'  | ''         | 'type'  |           1 | 'http://snomed.info/sct' |     1 |          1 |
   {% endcall %}
)
{{ compare_tables("expect", "result")}}

{% endmacro %}