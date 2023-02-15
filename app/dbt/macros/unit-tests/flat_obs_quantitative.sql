{% macro data_flatten_obs_weight() %}
{
	"resourceType": "Observation",
	"id": "example",
	"status": "amended",
	"category": [
		{
			"coding": [
				{
					"system": "http://terminology.hl7.org/CodeSystem/observation-category",
					"code": "vital-signs",
					"display": "Vital Signs"
				}
			],
			"text": "Vital Signs"
		}
	],
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
				"system": "urn:oid:1.2.246.537.6.96",
				"code": "29463-7"
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
	},
	"subject": {
		"reference": "Patient/eO6oPEoiC084jCETqSU7y-w3",
		"display": "Kid, Aiden Jr."
	},
	"effectiveDateTime": "2021-02-14T15:15:00Z",
	"issued": "2021-02-14T17:00:00Z",
	"valueQuantity": {
		"value": 12,
		"unit": "kg",
		"system": "http://unitsofmeasure.org",
		"code": "kg"
	}
}
{% endmacro %}

{% macro data_flatten_obs_dar() %}
{
  "resourceType": "Observation",
  "id": "example",
  "status": "cancelled",
  "code": {
    "coding": [{
        "system": "http://loinc.org",
        "code": "15074-8",
        "display": "Glucose [Moles/volume] in Blood"
      }]
  },
  "subject": {
    "reference": "Patient/f001",
    "display": "P. van de Heuvel"
  },
  "dataAbsentReason": {
    "coding": [{
        "system": "http://snomed.info/sct",
        "code": "125154007",
        "display": "Specimen unsatisfactory for evaluation"
      }]
  }
}
{% endmacro %}

{% macro data_flatten_obs_non_numeric() %}
{
  "resourceType": "Observation",
  "id": "example",
  "status": "final",
  "code": {
    "coding": [
      {
        "system": "http://acmelabs.org",
        "code": "104177",
        "display": "Blood culture"
      },
      {
        "system": "http://loinc.org",
        "code": "600-7",
        "display": "Bacteria identified in Blood by Culture"
      }
    ]
  },
  "issued": "2013-03-11T10:28:00+01:00",
  "valueCodeableConcept": {
    "coding": [
      {
        "system": "http://snomed.info/sct",
        "code": "3092008",
        "display": "Staphylococcus aureus"
      }
    ]
  }
}
{% endmacro %}

{% macro data_flatten_obs_has_components() %}
{
  "resourceType": "Observation",
  "id": "blood-pressure",
  "component": [
    {
      "code": {
        "coding": [
          {
            "system": "http://loinc.org",
            "code": "8480-6",
            "display": "Systolic blood pressure"
          },
          {
            "system": "http://snomed.info/sct",
            "code": "271649006",
            "display": "Systolic blood pressure"
          },
          {
            "system": "http://acme.org/devices/clinical-codes",
            "code": "bp-s",
            "display": "Systolic Blood pressure"
          }
        ]
      },
      "valueQuantity": {
        "value": 107,
        "unit": "mmHg",
        "system": "http://unitsofmeasure.org",
        "code": "mm[Hg]"
      },
      "interpretation": [
        {
          "coding": [
            {
              "system": "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation",
              "code": "N",
              "display": "normal"
            }
          ],
          "text": "Normal"
        }
      ]
    },
    {
      "code": {
        "coding": [
          {
            "system": "http://loinc.org",
            "code": "8462-4",
            "display": "Diastolic blood pressure"
          }
        ]
      },
      "valueQuantity": {
        "value": 60,
        "unit": "mmHg",
        "system": "http://unitsofmeasure.org",
        "code": "mm[Hg]"
      },
      "interpretation": [
        {
          "coding": [
            {
              "system": "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation",
              "code": "L",
              "display": "low"
            }
          ],
          "text": "Below low normal"
        }
      ]
    }
  ]
}
{% endmacro %}

{% macro test_flatten_obs() %}
WITH fhir AS (
	{{ import_json( data_flatten_obs_weight() ) }}
),
flat AS (
	{{ flat_obs_quantitative('fhir', 'resource') }}
),
expect AS (
	{% call table_to_sql() %}
	| id        | subject                            | effective_date_time    | system                                                                   | code                       | display                | quantity_value | quantity_system             | quantity_code | has_data_absent::boolean |
	|-----------|------------------------------------|------------------------|--------------------------------------------------------------------------|----------------------------|------------------------|----------------|-----------------------------|---------------|--------------------------|
	| 'example' | 'Patient/eO6oPEoiC084jCETqSU7y-w3' | '2021-02-14T15:15:00Z' | 'urn:oid:1.2.840.114350.1.13.1.1.7.2.707679'                             | '14'                       | 'Weight'               | 12             | 'http://unitsofmeasure.org' | 'kg'          | NULL                     |
	| 'example' | 'Patient/eO6oPEoiC084jCETqSU7y-w3' | '2021-02-14T15:15:00Z' | 'http://open.epic.com/FHIR/StructureDefinition/observation-flowsheet-id' | 'ttjlASTxfaxgiecvotrb78w0' | 'Weight'               | 12             | 'http://unitsofmeasure.org' | 'kg'          | NULL                     |
	| 'example' | 'Patient/eO6oPEoiC084jCETqSU7y-w3' | '2021-02-14T15:15:00Z' | 'urn:oid:1.2.246.537.6.96'                                               | '29463-7'                  | NULL                   | 12             | 'http://unitsofmeasure.org' | 'kg'          | NULL                     |
	| 'example' | 'Patient/eO6oPEoiC084jCETqSU7y-w3' | '2021-02-14T15:15:00Z' | 'http://loinc.org'                                                       | '29463-7'                  | 'Body weight'          | 12             | 'http://unitsofmeasure.org' | 'kg'          | NULL                     |
	| 'example' | 'Patient/eO6oPEoiC084jCETqSU7y-w3' | '2021-02-14T15:15:00Z' | 'http://loinc.org'                                                       | '3141-9'                   | 'Body weight Measured' | 12             | 'http://unitsofmeasure.org' | 'kg'          | NULL                     |
	| 'example' | 'Patient/eO6oPEoiC084jCETqSU7y-w3' | '2021-02-14T15:15:00Z' | 'http://loinc.org'                                                       | '8716-3'                   | 'Vital signs'          | 12             | 'http://unitsofmeasure.org' | 'kg'          | NULl                     |
	{% endcall %}
)

{{ compare_tables("expect", "flat")}}

{% endmacro %}

{% macro test_flatten_obs_dar() %}
WITH fhir AS (
	{{ import_json( data_flatten_obs_dar() ) }}
),
flat AS (
	{{ flat_obs_quantitative('fhir', 'resource') }}
),
expect AS (
	{% call table_to_sql() %}
	| id        | subject        | effective_date_time   | system             | code      | display                           | quantity_value::NUMERIC  | quantity_system   | quantity_code   | has_data_absent   |
	|-----------|----------------|-----------------------|--------------------|-----------|-----------------------------------|------------------|-------------------|-----------------|-------------------|
	| 'example' | 'Patient/f001' | NULL                  | 'http://loinc.org' | '15074-8' | 'Glucose [Moles/volume] in Blood' | NULL             | NULL              | NULL            | True              |
	{% endcall %}
)

{{ compare_tables("expect", "flat")}}

{% endmacro %}

{% macro test_flatten_skip_non_quantitative() %}
WITH fhir AS (
	{{ import_json( data_flatten_obs_non_numeric() ) }}
),
flat AS (
	{{ flat_obs_quantitative('fhir', 'resource') }}
)
SELECT * FROM flat
{% endmacro %}

{% macro test_flatten_obs_ignore_components() %}
WITH fhir AS (
	{{ import_json( data_flatten_obs_has_components() ) }}
),
flat AS (
	{{ flat_obs_quantitative('fhir', 'resource') }}
)
SELECT * FROM flat
{% endmacro %}

{% macro test_flatten_obs_multiple() %}
WITH fhir AS (
	{{ import_json( data_flatten_obs_weight() ) }}
  UNION ALL
	{{ import_json( data_flatten_obs_dar() ) }}
),
flat AS (
	{{ flat_obs_quantitative('fhir', 'resource') }}
),
expect AS (
	{% call table_to_sql() %}
	| id        | subject                            | effective_date_time    | system                                                                   | code                       | display                | quantity_value | quantity_system             | quantity_code | has_data_absent::boolean |
	|-----------|------------------------------------|------------------------|--------------------------------------------------------------------------|----------------------------|------------------------|----------------|-----------------------------|---------------|--------------------------|
	| 'example' | 'Patient/eO6oPEoiC084jCETqSU7y-w3' | '2021-02-14T15:15:00Z' | 'urn:oid:1.2.840.114350.1.13.1.1.7.2.707679'                             | '14'                       | 'Weight'               | 12             | 'http://unitsofmeasure.org' | 'kg'          | NULL                     |
	| 'example' | 'Patient/eO6oPEoiC084jCETqSU7y-w3' | '2021-02-14T15:15:00Z' | 'http://open.epic.com/FHIR/StructureDefinition/observation-flowsheet-id' | 'ttjlASTxfaxgiecvotrb78w0' | 'Weight'               | 12             | 'http://unitsofmeasure.org' | 'kg'          | NULL                     |
	| 'example' | 'Patient/eO6oPEoiC084jCETqSU7y-w3' | '2021-02-14T15:15:00Z' | 'urn:oid:1.2.246.537.6.96'                                               | '29463-7'                  | NULL                   | 12             | 'http://unitsofmeasure.org' | 'kg'          | NULL                     |
	| 'example' | 'Patient/eO6oPEoiC084jCETqSU7y-w3' | '2021-02-14T15:15:00Z' | 'http://loinc.org'                                                       | '29463-7'                  | 'Body weight'          | 12             | 'http://unitsofmeasure.org' | 'kg'          | NULL                     |
	| 'example' | 'Patient/eO6oPEoiC084jCETqSU7y-w3' | '2021-02-14T15:15:00Z' | 'http://loinc.org'                                                       | '3141-9'                   | 'Body weight Measured' | 12             | 'http://unitsofmeasure.org' | 'kg'          | NULL                     |
	| 'example' | 'Patient/eO6oPEoiC084jCETqSU7y-w3' | '2021-02-14T15:15:00Z' | 'http://loinc.org'                                                       | '8716-3'                   | 'Vital signs'          | 12             | 'http://unitsofmeasure.org' | 'kg'          | NULl                     |
	{% endcall %}
  UNION ALL
	{% call table_to_sql() %}
	| id        | subject        | effective_date_time   | system             | code      | display                           | quantity_value::NUMERIC  | quantity_system   | quantity_code   | has_data_absent   |
	|-----------|----------------|-----------------------|--------------------|-----------|-----------------------------------|------------------|-------------------|-----------------|-------------------|
	| 'example' | 'Patient/f001' | NULL                  | 'http://loinc.org' | '15074-8' | 'Glucose [Moles/volume] in Blood' | NULL             | NULL              | NULL            | True              |
	{% endcall %}
)

{{ compare_tables("expect", "flat")}}

{% endmacro %}