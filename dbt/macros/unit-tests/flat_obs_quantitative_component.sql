{% macro data_flatten_component_obs_bp() %}
{
  "resourceType": "Observation",
  "id": "blood-pressure",
  "meta": {
    "profile": [
      "http://hl7.org/fhir/StructureDefinition/vitalsigns"
    ]
  },
  "identifier": [
    {
      "system": "urn:ietf:rfc:3986",
      "value": "urn:uuid:187e0c12-8dd2-67e2-99b2-bf273c878281"
    }
  ],
  "basedOn": [
    {
      "identifier": {
        "system": "https://acme.org/identifiers",
        "value": "1234"
      }
    }
  ],
  "status": "final",
  "category": [
    {
      "coding": [
        {
          "system": "http://terminology.hl7.org/CodeSystem/observation-category",
          "code": "vital-signs",
          "display": "Vital Signs"
        }
      ]
    }
  ],
  "code": {
    "coding": [
      {
        "system": "http://loinc.org",
        "code": "85354-9",
        "display": "Blood pressure panel with all children optional"
      }
    ],
    "text": "Blood pressure systolic & diastolic"
  },
  "subject": {
    "reference": "Patient/example"
  },
  "effectiveDateTime": "2012-09-17",
  "performer": [
    {
      "reference": "Practitioner/example"
    }
  ],
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
  ],
  "bodySite": {
    "coding": [
      {
        "system": "http://snomed.info/sct",
        "code": "368209003",
        "display": "Right arm"
      }
    ]
  },
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

{% macro data_flatten_component_obs_bp_dar() %}
{
  "resourceType" : "Observation",
  "id" : "bp-data-absent",
  "status" : "final",
  "category" : [
    {
      "coding" : [
        {
          "system" : "http://terminology.hl7.org/CodeSystem/observation-category",
          "code" : "vital-signs",
          "display" : "Vital Signs"
        }
      ],
      "text" : "Vital Signs"
    }
  ],
  "code" : {
    "coding" : [
      {
        "system" : "http://loinc.org",
        "code" : "85354-9",
        "display" : "Blood pressure panel with all children optional"
      }
    ],
    "text" : "Blood pressure systolic and diastolic"
  },
  "subject" : {
    "reference" : "Patient/example",
    "display" : "Amy Shaw"
  },
  "encounter" : {
    "reference" : "Encounter/1036"
  },
  "effectiveDateTime" : "1999-07-02",
  "component" : [
    {
      "code" : {
        "coding" : [
          {
            "system" : "http://loinc.org",
            "code" : "8480-6",
            "display" : "Systolic blood pressure"
          }
        ],
        "text" : "Systolic blood pressure"
      },
      "valueQuantity" : {
        "value" : 109,
        "unit" : "mmHg",
        "system" : "http://unitsofmeasure.org",
        "code" : "mm[Hg]"
      }
    },
    {
      "code" : {
        "coding" : [
          {
            "system" : "http://loinc.org",
            "code" : "8462-4",
            "display" : "Diastolic blood pressure"
          }
        ],
        "text" : "Diastolic blood pressure"
      },
      "dataAbsentReason" : {
        "coding" : [
          {
            "system" : "http://terminology.hl7.org/CodeSystem/data-absent-reason",
            "code" : "unknown",
            "display" : "Unknown"
          }
        ],
        "text" : "Unknown"
      }
    }
  ]
}
{% endmacro %}

{% macro data_flatten_component_obs_non_numeric() %}
{
  "resourceType": "Observation",
  "id": "example",
  "status": "final",
  "issued": "2013-03-11T10:28:00+01:00",
  "component": [{      
    "code": {
      "coding": [{
          "system": "http://loinc.org",
          "code": "8480-6"
        }]
      },
    "valueCodeableConcept": {
      "coding": [{
        "system": "http://snomed.info/sct",
        "code": "3092008",
        "display": "Staphylococcus aureus"
      }]
    }
  }]
}
{% endmacro %}

{% macro data_flatten_component_obs_weight() %}
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

{% macro data_flatten_component_obs_empty_component() %}
{
  "resourceType": "Observation",
  "id": "example",
  "status": "final",
  "issued": "2013-03-11T10:28:00+01:00",
  "component": []
}
{% endmacro %}

{% macro test_flatten_component_obs_skip_non_numeric() %}

WITH fhir AS (
  {{ import_json( data_flatten_component_obs_non_numeric() ) }}
),
flat AS (
	{{ flat_obs_quantitative_component('fhir', 'resource') }}
)
SELECT * FROM flat

{% endmacro %}

{% macro test_flatten_component_obs_bp() %}
WITH fhir AS (
	{{ import_json( data_flatten_component_obs_bp() ) }}
),
flat AS (
	{{ flat_obs_quantitative_component('fhir', 'resource') }}
),
expect AS (
	{% call table_to_sql() %}
  | obs_id           | subject           | effective_date_time   | obs_system         | obs_code   | obs_display                                       | code        | system                                   | display                    | id                 |   quantity_value | quantity_system             | quantity_code   | has_data_absent::BOOLEAN   |
  |------------------|-------------------|-----------------------|--------------------|------------|---------------------------------------------------|-------------|------------------------------------------|----------------------------|--------------------|------------------|-----------------------------|------------------|-------------------|
  | 'blood-pressure' | 'Patient/example' | '2012-09-17'          | 'http://loinc.org' | '85354-9'  | 'Blood pressure panel with all children optional' | '8480-6'    | 'http://loinc.org'                       | 'Systolic blood pressure'  | 'blood-pressure-1' |              107 | 'http://unitsofmeasure.org' | 'mm[Hg]'         | NULL              |
  | 'blood-pressure' | 'Patient/example' | '2012-09-17'          | 'http://loinc.org' | '85354-9'  | 'Blood pressure panel with all children optional' | '271649006' | 'http://snomed.info/sct'                 | 'Systolic blood pressure'  | 'blood-pressure-1' |              107 | 'http://unitsofmeasure.org' | 'mm[Hg]'         | NULL              |
  | 'blood-pressure' | 'Patient/example' | '2012-09-17'          | 'http://loinc.org' | '85354-9'  | 'Blood pressure panel with all children optional' | 'bp-s'      | 'http://acme.org/devices/clinical-codes' | 'Systolic Blood pressure'  | 'blood-pressure-1' |              107 | 'http://unitsofmeasure.org' | 'mm[Hg]'         | NULL              |
  | 'blood-pressure' | 'Patient/example' | '2012-09-17'          | 'http://loinc.org' | '85354-9'  | 'Blood pressure panel with all children optional' | '8462-4'    | 'http://loinc.org'                       | 'Diastolic blood pressure' | 'blood-pressure-2' |               60 | 'http://unitsofmeasure.org' | 'mm[Hg]'         | NULL              |
  {% endcall %}
)

{{ compare_tables("expect", "flat")}}

{% endmacro %}

{% macro test_flatten_component_obs_dar() %}
WITH fhir AS (
	{{ import_json( data_flatten_component_obs_bp_dar() ) }}
),
flat AS (
	{{ flat_obs_quantitative_component('fhir', 'resource') }}
),
expect AS (
	{% call table_to_sql() %}
  | obs_id           | subject           | effective_date_time   | obs_system         | obs_code   | obs_display                                       | code     | system             | display                    | id                 | quantity_value   | quantity_system             | quantity_code    | has_data_absent   |
  |------------------|-------------------|-----------------------|--------------------|------------|---------------------------------------------------|----------|--------------------|----------------------------|--------------------|------------------|-----------------------------|------------------|-------------------|
  | 'bp-data-absent' | 'Patient/example' | '1999-07-02'          | 'http://loinc.org' | '85354-9'  | 'Blood pressure panel with all children optional' | '8480-6' | 'http://loinc.org' | 'Systolic blood pressure'  | 'bp-data-absent-1' | 109.0            | 'http://unitsofmeasure.org' | 'mm[Hg]'         | NULL              |
  | 'bp-data-absent' | 'Patient/example' | '1999-07-02'          | 'http://loinc.org' | '85354-9'  | 'Blood pressure panel with all children optional' | '8462-4' | 'http://loinc.org' | 'Diastolic blood pressure' | 'bp-data-absent-2' | NULL             | NULL                        | NULL             | True              |
  {% endcall %}
)

{{ compare_tables("expect", "flat")}}
{% endmacro %}

{% macro test_flatten_component_obs_ignore_non_component() %}
WITH fhir AS (
  {{ import_json( data_flatten_component_obs_weight() ) }}
),
flat AS (
	{{ flat_obs_quantitative_component('fhir', 'resource') }}
)
SELECT * FROM flat
{% endmacro %}

{% macro test_flatten_component_obs_ignore_empty_component() %}
WITH fhir AS (
  {{ import_json( data_flatten_component_obs_empty_component() ) }}
),
flat AS (
	{{ flat_obs_quantitative_component('fhir', 'resource') }}
)
SELECT * FROM flat
{% endmacro %}

{% macro test_flatten_component_obs_multiple() %}
WITH fhir AS (
	{{ import_json( data_flatten_component_obs_bp() ) }}
  UNION ALL
	{{ import_json( data_flatten_component_obs_bp_dar() ) }}
),
flat AS (
	{{ flat_obs_quantitative_component('fhir', 'resource') }}
),
expect AS (
	{% call table_to_sql() %}
  | obs_id           | subject           | effective_date_time   | obs_system         | obs_code   | obs_display                                       | code        | system                                   | display                    | id                 |   quantity_value | quantity_system             | quantity_code   | has_data_absent::BOOLEAN   |
  |------------------|-------------------|-----------------------|--------------------|------------|---------------------------------------------------|-------------|------------------------------------------|----------------------------|--------------------|------------------|-----------------------------|------------------|-------------------|
  | 'blood-pressure' | 'Patient/example' | '2012-09-17'          | 'http://loinc.org' | '85354-9'  | 'Blood pressure panel with all children optional' | '8480-6'    | 'http://loinc.org'                       | 'Systolic blood pressure'  | 'blood-pressure-1' |              107 | 'http://unitsofmeasure.org' | 'mm[Hg]'         | NULL              |
  | 'blood-pressure' | 'Patient/example' | '2012-09-17'          | 'http://loinc.org' | '85354-9'  | 'Blood pressure panel with all children optional' | '271649006' | 'http://snomed.info/sct'                 | 'Systolic blood pressure'  | 'blood-pressure-1' |              107 | 'http://unitsofmeasure.org' | 'mm[Hg]'         | NULL              |
  | 'blood-pressure' | 'Patient/example' | '2012-09-17'          | 'http://loinc.org' | '85354-9'  | 'Blood pressure panel with all children optional' | 'bp-s'      | 'http://acme.org/devices/clinical-codes' | 'Systolic Blood pressure'  | 'blood-pressure-1' |              107 | 'http://unitsofmeasure.org' | 'mm[Hg]'         | NULL              |
  | 'blood-pressure' | 'Patient/example' | '2012-09-17'          | 'http://loinc.org' | '85354-9'  | 'Blood pressure panel with all children optional' | '8462-4'    | 'http://loinc.org'                       | 'Diastolic blood pressure' | 'blood-pressure-2' |               60 | 'http://unitsofmeasure.org' | 'mm[Hg]'         | NULL              |
  {% endcall %}
  UNION ALL
	{% call table_to_sql() %}
  | obs_id           | subject           | effective_date_time   | obs_system         | obs_code   | obs_display                                       | code     | system             | display                    | id                 | quantity_value   | quantity_system             | quantity_code   | has_data_absent   |
  |------------------|-------------------|-----------------------|--------------------|------------|---------------------------------------------------|----------|--------------------|----------------------------|--------------------|------------------|-----------------------------|------------------|-------------------|
  | 'bp-data-absent' | 'Patient/example' | '1999-07-02'          | 'http://loinc.org' | '85354-9'  | 'Blood pressure panel with all children optional' | '8480-6' | 'http://loinc.org' | 'Systolic blood pressure'  | 'bp-data-absent-1' | 109              | 'http://unitsofmeasure.org' | 'mm[Hg]'         | NULL              |
  | 'bp-data-absent' | 'Patient/example' | '1999-07-02'          | 'http://loinc.org' | '85354-9'  | 'Blood pressure panel with all children optional' | '8462-4' | 'http://loinc.org' | 'Diastolic blood pressure' | 'bp-data-absent-2' | NULL             | NULL                        | NULL             | True              |
  {% endcall %}
)

{{ compare_tables("expect", "flat")}}

{% endmacro %}
