{% macro data_count_obs_weight() %}
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
	"subject": {
		"reference": "Patient/eO6oPEoiC084jCETqSU7y-w3",
		"display": "Kid, Aiden Jr."
	},
	"effectiveDateTime": "2021-02-14T15:15:00Z",
	"issued": "2021-02-14T17:00:00Z"
}
{% endmacro %}

{% macro data_count_obs_weight_2() %}
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
	"subject": {
		"reference": "Patient/eO6oPEoiC084jCETqSU7y-w3",
		"display": "Kid, Aiden Jr."
	},
	"effectiveDateTime": "2021-02-22",
	"issued": "2021-02-14T17:00:00Z"
}
{% endmacro %}

{% macro data_count_obs_weight_3() %}
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
	"subject": {
		"reference": "Patient/eO6oPEoiC084jCETqSU7y-w3",
		"display": "Kid, Aiden Jr."
	},
	"effectiveDateTime": "2021-01-22",
	"issued": "2021-02-14T17:00:00Z"
}
{% endmacro %}

{% macro data_count_condition() %}
{
	"resourceType": "Condition",
	"id": "example1",
	"category": [{
		"coding": [{
				"system": "http://terminology.hl7.org/CodeSystem/condition-category",
				"code": "problem-list-item",
				"display": "Problem List Item"
			}],
		"text": "Problem List Item"
	}],
	"subject": {
		"reference": "Patient/eO6oPEoiC084jCETqSU7y-w3",
		"display": "Kid, Aiden Jr."
	},
	"onsetPeriod": {
		"start": "2019-01-24",
		"end": "2019-01-24"
	},
	"recordedDate": "2021-02-14"
}
{% endmacro %}

{% macro data_count_document_reference() %}
{
	"resourceType": "DocumentReference",
	"id": "eeFpluqNp7Shf.jP.KW4K1xMLcijrg6l1Zv.xiOHz.1Y3",
	"status": "current",
	"docStatus": "final",
	"type": {
		"coding": [
			{
				"system": "http://loinc.org",
				"code": "11506-3",
				"display": "Progress Note"
			},
			{
				"system": "urn:oid:1.2.840.114350.1.13.861.1.7.4.737880.5010",
				"code": "1",
				"display": "Progress Notes"
			}
		],
		"text": "Progress Note"
	},
	"category": [
		{
			"coding": [
				{
					"system": "http://hl7.org/fhir/us/core/CodeSystem/us-core-documentreference-category",
					"code": "clinical-note",
					"display": "Clinical Note"
				}
			],
			"text": "Clinical Note"
		}
	],
	"subject": {
		"reference": "Patient/e7XZi7JJ6AZSxlmZBc9-Rdw3",
		"display": "Fhir D Cds Jr., DDS"
	},
	"date": "2019-05-21T20:19:30Z",
	"author": [
		{
			"reference": "Practitioner/e1iKCKct1N3beTTPAUSJN7A3",
			"display": "User, Epic, RPh"
		}
	],
	"content": [
		{
			"attachment": {
				"contentType": "text/html",
				"url": "Binary/ekAJmRWsOeeVsqjgMnmX-5ZTCqyW.NZW3fvSH8mNXZSg3"
			}
		}
	],
	"context": {
		"encounter": [
			{
				"reference": "Encounter/eUYzqPWXxEvtcwrItyp7H3xYs37qc3b3dYZln86UIj.43"
			}
		],
		"period": {
			"start": "2019-05-21T04:59:00Z"
		}
	}
}
{% endmacro %}

{% macro data_count_medication_request() %}
{
  "resourceType": "MedicationRequest",
  "id": "eJk0ebNUOTKx9f80aYoZPHg3",
  "identifier": [
    {
      "use": "usual",
      "system": "urn:oid:1.2.840.114350.1.13.0.1.7.2.798268",
      "value": "882173"
    }
  ],
  "status": "active",
  "intent": "plan",
  "category": [
    {
      "coding": [
        {
          "system": "http://terminology.hl7.org/CodeSystem/medicationrequest-category",
          "code": "community",
          "display": "Community"
        }
      ],
      "text": "Community"
    }
  ],
  "reportedBoolean": true,
  "medicationReference": {
    "reference": "Medication/en0IpPR7jJ9u2aTvV-F20Tj7oIUehIqKfygWYu5Tt9l2GpPo3ZYvVCUT5TKmWwCU63",
    "display": "CALCIUM + D PO"
  },
  "subject": {
    "reference": "Patient/e.Rxkbv0HmfyDyboA-LtyRQ3",
    "display": "Ambulatory, Beth"
  },
  "encounter": {
    "identifier": {
      "use": "usual",
      "system": "urn:oid:1.2.840.114350.1.13.0.1.7.3.698084.8",
      "value": "10096"
    },
    "display": "Initial Prenatal"
  },
  "authoredOn": "2013-04-29",
  "requester": {
    "extension": [
      {
        "valueCode": "unknown",
        "url": "http://hl7.org/fhir/StructureDefinition/data-absent-reason"
      }
    ]
  },
  "recorder": {
    "reference": "Practitioner/eyOHsvt3quDQ4aJ38tl.ywQ3",
    "type": "Practitioner",
    "display": "Nurse Obstetrics, RN"
  },
  "courseOfTherapyType": {
    "coding": [
      {
        "system": "http://terminology.hl7.org/CodeSystem/medicationrequest-course-of-therapy",
        "code": "acute",
        "display": "Short course (acute) therapy"
      }
    ],
    "text": "Short course (acute) therapy"
  }
}
{% endmacro %}

{% macro data_count_encounter() %}
{
	"resourceType": "Encounter",
	"id": "e1QDDhX1HbcvEGeAksCj1qA3",
	"identifier": [
		{
			"use": "usual",
			"system": "urn:oid:1.2.840.114350.1.13.1.1.7.3.698084.8",
			"value": "2"
		}
	],
	"status": "in-progress",
	"class": {
		"system": "urn:oid:1.2.840.114350.1.72.1.7.7.10.696784.13260",
		"code": "13",
		"display": "Support OP Encounter"
	},
	"type" : [{
		"coding" : [{
			"system" : "http://www.ama-assn.org/go/cpt",
			"code" : "99201"
		}],
		"text" : "Office Visit"
	}],
	"subject": {
		"reference": "Patient/eO6oPEoiC084jCETqSU7y-w3",
		"display": "Kid, Aiden Jr."
	},
	"episodeOfCare": [
		{
			"reference": "EpisodeOfCare/eGRFYbtxb3h7v.olsZZw7zA3",
			"type": "EpisodeOfCare",
			"display": "Childhood Obesity Prevention and Management"
		}
	],
	"participant": [
		{
			"extension": [
				{
					"valueCodeableConcept": {
						"coding": [
							{
								"system": "urn:oid:1.2.840.114350.1.13.1.1.7.4.698084.18832",
								"code": "52",
								"display": "Nuclear Medicine"
							}
						],
						"text": "Nuclear Medicine"
					},
					"url": "http://open.epic.com/FHIR/StructureDefinition/extension/specialty"
				}
			],
			"period": {
				"start": "2021-07-25T20:50:21Z"
			},
			"individual": {
				"reference": "Practitioner/eQ.c9ZqRHPt1hds3Heosjxg3",
				"type": "Practitioner",
				"display": "Alan Adams, MD"
			}
		},
		{
			"extension": [
				{
					"valueCodeableConcept": {
						"coding": [
							{
								"system": "urn:oid:1.2.840.114350.1.13.1.1.7.4.698084.18832",
								"code": "52",
								"display": "Nuclear Medicine"
							}
						],
						"text": "Nuclear Medicine"
					},
					"url": "http://open.epic.com/FHIR/StructureDefinition/extension/specialty"
				}
			],
			"period": {
				"start": "2021-07-25T20:52:28Z"
			},
			"individual": {
				"reference": "Practitioner/eSV-xYzZIBxmgwXcQt5TtdA3",
				"type": "Practitioner",
				"display": "Sas Provider"
			}
		}
	],
	"period": {
		"start": "2021-02-14",
		"end": "2021-02-14"
	},
	"location": [
		{
			"location": {
				"reference": "Location/e0BVMzBLQZnOzQuBgZacQDA3",
				"display": "WI Harbor Bluff North Surgery"
			}
		}
	]
}
{% endmacro %}

{% macro test_c_resource_count_obs_same_dates() %}
WITH fhir AS (
	{{ import_json( data_count_obs_weight() ) }}
	UNION ALL
	{{ import_json( data_count_obs_weight_2() ) }}

),
result AS (
	{{ c_resource_count_nested_category('fhir', 'resource') }}
),
expect AS (
	{% call table_to_sql() %}
   | resourcetype   |   primary_year |   primary_month | category      |   cnt |
   |----------------|----------------|-----------------|---------------|-------|
   | 'Observation'  |           2021 |               2 | 'vital-signs' |     2 |
   	{% endcall %}
)

{{ compare_tables("expect", "result")}}

{% endmacro %}

{% macro test_c_resource_count_obs_different_dates() %}
WITH fhir AS (
	{{ import_json( data_count_obs_weight() ) }}
	UNION ALL
	{{ import_json( data_count_obs_weight_3() ) }}

),
result AS (
	{{ c_resource_count_nested_category('fhir', 'resource') }}
),
expect AS (
	{% call table_to_sql() %}
   | resourcetype   |   primary_year |   primary_month | category      |   cnt |
   |----------------|----------------|-----------------|---------------|-------|
   | 'Observation'  |           2021 |               2 | 'vital-signs' |     1 |
   | 'Observation'  |           2021 |               1 | 'vital-signs' |     1 |
   	{% endcall %}
)

{{ compare_tables("expect", "result")}}

{% endmacro %}

{% macro test_c_resource_count_nested_category_collapse_categories() %}

WITH fhir AS (
	{{ import_json('{
		"id": "123",
		"category": [{
		"coding": [{
			"system": "http://terminology.hl7.org/CodeSystem/observation-category",
			"code": "cat2"
		},{
			"system": "http://terminology.hl7.org/CodeSystem/observation-category",
			"code": "cat1"
		}]
	},{
		"coding": [{
			"system": "http://terminology.hl7.org/CodeSystem/observation-category",
			"code": "cat3"
		}]
	}]
	}') }}
),
metric AS (
	{{ c_resource_count_nested_category('fhir', 'resource') }}
),
result AS (
	SELECT category FROM metric
),
expect AS (
	SELECT  'cat1,cat2,cat3' as category
)
{{ compare_tables("expect", "result")}}
{% endmacro %}

{% macro test_c_resource_count_nested_category_ignore_other_systems() %}

WITH fhir AS (
	{{ import_json('{
		"id": "123",
		"category": [{
		"coding": [{
			"system": "http://terminology.hl7.org/CodeSystem/observation-category",
			"code": "cat1"
		},{
			"system": "http://terminology.hl7.org/CodeSystem/not-observation-category",
			"code": "cat2"
		}]
	},{
		"coding": [{
			"system": "http://terminology.hl7.org/CodeSystem/observation-category",
			"code": "cat3"
		}]
	}]
	}') }}
),
metric AS (
	{{ c_resource_count_nested_category('fhir', 'resource', False, "Observation") }}
),
result AS (
	SELECT category FROM metric
),
expect AS (
	SELECT  'cat1,cat3' as category
)
{{ compare_tables("expect", "result")}}
{% endmacro %}

{% macro test_c_resource_count_obs_skip_dates() %}
WITH fhir AS (
	{{ import_json( data_count_obs_weight() ) }}
),
result AS (
	{{ c_resource_count_nested_category('fhir', 'resource', False, "Observation", True) }}
),
expect AS (
	{% call table_to_sql() %}
   | resourcetype   |   primary_year |   primary_month | category      |   cnt |
   |----------------|----------------|-----------------|---------------|-------|
   | 'Observation'  |           NULL |            NULL | 'vital-signs' |     1 |
   	{% endcall %}
)

{{ compare_tables("expect", "result")}}

{% endmacro %}

{% macro test_c_resource_count_obs_skip_category() %}
WITH fhir AS (
	{{ import_json( data_count_obs_weight() ) }}
),
result AS (
	{{ c_resource_count_nested_category('fhir', 'resource', False, "Observation", False, True) }}
),
expect AS (
	{% call table_to_sql() %}
   | resourcetype   |   primary_year |   primary_month | category      |   cnt |
   |----------------|----------------|-----------------|---------------|-------|
   | 'Observation'  |           2021 |               2 | NULL          |     1 |
   	{% endcall %}
)

{{ compare_tables("expect", "result")}}

{% endmacro %}

{% macro test_c_resource_count_condition() %}
WITH fhir AS (
	{{ import_json( data_count_condition() ) }}
),
result AS (
	{{ c_resource_count_nested_category('fhir', 'resource', False, "Condition") }}
),
expect AS (
	{% call table_to_sql() %}
   | resourceType   |   primary_year |   primary_month | category            |   cnt |
   |----------------|----------------|-----------------|---------------------|-------|
   | 'Condition'    |           2021 |               2 | 'problem-list-item' |     1 |
   	{% endcall %}
)

{{ compare_tables("expect", "result")}}

{% endmacro %}

{% macro test_c_resource_count_medication_request() %}
WITH fhir AS (
	{{ import_json( data_count_medication_request() ) }}
),
result AS (
	{{ c_resource_count_nested_category('fhir', 'resource', False, "MedicationRequest") }}
),
expect AS (
	{% call table_to_sql() %}
   | resourceType        |   primary_year |   primary_month | category    |   cnt |
   |---------------------|----------------|-----------------|-------------|-------|
   | 'MedicationRequest' |           2013 |               4 | 'community' |     1 |
   	{% endcall %}
)

{{ compare_tables("expect", "result")}}
{% endmacro %}

{% macro test_c_resource_count_encounter() %}
WITH fhir AS (
	{{ import_json( data_count_encounter() ) }}
),
result AS (
	{{ c_resource_count_nested_category('fhir', 'resource', False, "Encounter") }}
),
expect AS (
	{% call table_to_sql() %}
   | resource_type   |   primary_year |   primary_month | category                                |   cnt |
   |-----------------|----------------|-----------------|-----------------------------------------|-------|
   | 'Encounter'     |           2021 |               2 | 'http://www.ama-assn.org/go/cpt\|99201' |     1 |
   {% endcall %}
)
{{ compare_tables("expect", "result")}}
{% endmacro %}

{% macro test_c_resource_count_condition_date_fallback() %}

WITH fhir_all_dates AS (
	{{ import_json('{
		"id": "123",
		"onsetDateTime": "2019-06-12",
		"recordedDate": "2020-03-05T16:54:50.000Z",
		"onsetPeriod": {
			"start": "2006-07-07",
			"end": "2005-07-07"
		}
	}') }}
),
fhir_no_recorded_date AS (
	{{ import_json('{
		"id": "123",
		"onsetDateTime": "2019-06-12",
		"onsetPeriod": {
			"start": "2006-07-07",
			"end": "2005-07-07"
		}
	}') }}
),
fhir_no_onset_date AS (
	{{ import_json('{
		"id": "123",
		"onsetPeriod": {
			"start": "2006-07-07",
			"end": "2005-07-07"
		}
	}') }}
),
fhir_no_date AS (
	{{ import_json('{
		"id": "123"
	}') }}
),
result AS (
	(
		{{ c_resource_count_nested_category('fhir_all_dates', 'resource', False, "Condition") }}
	) UNION ALL (
		{{ c_resource_count_nested_category('fhir_no_recorded_date', 'resource', False, "Condition") }}
	) UNION ALL (
		{{ c_resource_count_nested_category('fhir_no_onset_date', 'resource', False, "Condition") }}
	) UNION ALL (
		{{ c_resource_count_nested_category('fhir_no_date', 'resource', False, "Condition") }}
	)
),
expect AS (
	{% call table_to_sql() %}
   | resourceType   | primary_year   | primary_month   | category   |   cnt |
   |----------------|----------------|-----------------|------------|-------|
   | NULL           | 2020           | 3               | NULL       |     1 |
   | NULL           | 2019           | 6               | NULL       |     1 |
   | NULL           | 2006           | 7               | NULL       |     1 |
   | NULL           | NULL           | NULL            | NULL       |     1 |
   	{% endcall %}
)

{{ compare_tables("expect", "result")}}

{% endmacro %}