{% macro data_count_allergy_intolerance() %}
{
  "resourceType": "AllergyIntolerance",
  "id": "example1",
  "clinicalStatus": {
    "coding": [
      {
        "system": "http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical",
        "version": "4.0.0",
        "code": "active",
        "display": "Active"
      }
    ]
  },
  "verificationStatus": {
    "coding": [
      {
        "system": "http://terminology.hl7.org/CodeSystem/allergyintolerance-verification",
        "version": "4.0.0",
        "code": "confirmed",
        "display": "Confirmed"
      }
    ]
  },
  "category": [
    "medication", "food"
  ],
  "code": {
    "coding": [
      {
        "system": "http://snomed.info/sct",
        "code": "COOPERTEST"
      }
    ],
    "text": "PENICILLINS"
  },
  "patient": {
    "reference": "Patient/e63wRTbPfr1p8UW81d8Seiw3",
    "display": "Mychart, Theodore"
  },
  "onsetPeriod": {
    "start": "2006-07-07"
  },
  "recordedDate": "2006-07-07T05:00:00Z"
}
{% endmacro %}

{% macro data_count_allergy_intolerance_2() %}
{
  "resourceType": "AllergyIntolerance",
  "id": "example2",
  "clinicalStatus": {
    "coding": [
      {
        "system": "http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical",
        "version": "4.0.0",
        "code": "active",
        "display": "Active"
      }
    ]
  },
  "verificationStatus": {
    "coding": [
      {
        "system": "http://terminology.hl7.org/CodeSystem/allergyintolerance-verification",
        "version": "4.0.0",
        "code": "confirmed",
        "display": "Confirmed"
      }
    ]
  },
  "category": ["medication"],
  "code": {
    "coding": [
      {
        "system": "http://snomed.info/sct",
        "code": "COOPERTEST"
      }
    ],
    "text": "PENICILLINS"
  },
  "patient": {
    "reference": "Patient/e63wRTbPfr1p8UW81d8Seiw3",
    "display": "Mychart, Theodore"
  },
  "onsetPeriod": {
    "start": "2006-07-07"
  },
  "recordedDate": "2006-07-07T05:00:00Z"
}
{% endmacro %}

{% macro test_c_resource_count_allergy_intolerance() %}
WITH fhir AS (
	{{ import_json( data_count_allergy_intolerance() ) }}
	UNION ALL
	{{ import_json( data_count_allergy_intolerance_2() ) }}
),
result AS (
	{{ c_resource_count_allergy_intolerance('fhir', 'resource', False) }}
),
expect AS (
	{% call table_to_sql() %}
    | resourcetype         |   primary_year |   primary_month | category          |   cnt |
    |----------------------|----------------|-----------------|-------------------|-------|
    | 'AllergyIntolerance' |           2006 |               7 | 'medication'      |     1 |
    | 'AllergyIntolerance' |           2006 |               7 | 'food,medication' |     1 |
	{% endcall %}
)

{{ compare_tables("expect", "result")}}
{% endmacro %}

{% macro test_c_resource_count_allergy_intolerance_skip_date() %}
WITH fhir AS (
	{{ import_json( data_count_allergy_intolerance() ) }}
),
result AS (
	{{ c_resource_count_allergy_intolerance('fhir', 'resource', False, True) }}
),
expect AS (
	{% call table_to_sql() %}
    | resourcetype         |   primary_year |   primary_month | category          |   cnt |
    |----------------------|----------------|-----------------|-------------------|-------|
    | 'AllergyIntolerance' |           NULL |            NULL | 'food,medication'      |     1 |
	{% endcall %}
)

{{ compare_tables("expect", "result")}}
{% endmacro %}

{% macro test_c_resource_count_allergy_intolerance_skip_category() %}
WITH fhir AS (
	{{ import_json( data_count_allergy_intolerance() ) }}
),
result AS (
	{{ c_resource_count_allergy_intolerance('fhir', 'resource', False, False, True) }}
),
expect AS (
	{% call table_to_sql() %}
    | resourcetype         |   primary_year |   primary_month | category          |   cnt |
    |----------------------|----------------|-----------------|-------------------|-------|
    | 'AllergyIntolerance' |           2006 |               7 | NULL              |     1 |
	{% endcall %}
)

{{ compare_tables("expect", "result")}}
{% endmacro %}

{% macro test_c_resource_count_allergy_intolerance_date_fallback() %}

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
		{{ c_resource_count_allergy_intolerance('fhir_all_dates', 'resource') }}
	) UNION ALL (
		{{ c_resource_count_allergy_intolerance('fhir_no_recorded_date', 'resource') }}
	) UNION ALL (
		{{ c_resource_count_allergy_intolerance('fhir_no_onset_date', 'resource') }}
	) UNION ALL (
		{{ c_resource_count_allergy_intolerance('fhir_no_date', 'resource') }}
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

