{% macro data_patient_no_extensions() %}
{
	"resourceType": "Patient",
	"id": "e63wRTbPfr1p8UW81d8Seiw3",
	"gender": "male",
	"birthDate": "1948-07-07",
	"maritalStatus": {"text": "Married"}
}

{% endmacro %}

{% macro data_patient_epic() %}
{
	"resourceType": "Patient",
	"id": "e63wRTbPfr1p8UW81d8Seiw3",
	"extension": [
	  {
		"extension": [
		  {
			"valueCoding": {
			  "system": "urn:oid:2.16.840.1.113883.6.238",
			  "code": "2106-3",
			  "display": "White"
			},
			"url": "ombCategory"
		  },
		  {
			"valueString": "White",
			"url": "text"
		  }
		],
		"url": "http://hl7.org/fhir/us/core/StructureDefinition/us-core-race"
	  },
	  {
		"extension": [
		  {
			"valueString": "Unknown",
			"url": "text"
		  }
		],
		"url": "http://hl7.org/fhir/us/core/StructureDefinition/us-core-ethnicity"
	  },
	  {
		"valueCodeableConcept": {
		  "coding": [
			{
			  "system": "urn:oid:1.2.840.114350.1.13.0.1.7.10.698084.130.657370.19999000",
			  "code": "male",
			  "display": "male"
			}
		  ]
		},
		"url": "http://open.epic.com/FHIR/StructureDefinition/extension/legal-sex"
	  },
	  {
		"valueCodeableConcept": {
		  "coding": [
			{
			  "system": "urn:oid:1.2.840.114350.1.13.0.1.7.10.698084.130.657370.19999000",
			  "code": "male",
			  "display": "male"
			}
		  ]
		},
		"url": "http://open.epic.com/FHIR/StructureDefinition/extension/sex-for-clinical-use"
	  },
	  {
		"valueCode": "M",
		"url": "http://hl7.org/fhir/us/core/StructureDefinition/us-core-birthsex"
	  }
	],
	"identifier": [
	  {
		"use": "usual",
		"system": "urn:oid:2.16.840.1.113883.4.1",
		"_value": {
		  "extension": [
			{
			  "valueString": "xxx-xx-4199",
			  "url": "http://hl7.org/fhir/StructureDefinition/rendered-value"
			}
		  ]
		}
	  },
	  {
		"use": "usual",
		"type": {
		  "text": "EPIC"
		},
		"system": "urn:oid:1.2.840.114350.1.13.0.1.7.5.737384.0",
		"value": "E2734"
	  },
	  {
		"use": "usual",
		"type": {
		  "text": "EXTERNAL"
		},
		"system": "urn:oid:1.2.840.114350.1.13.0.1.7.2.698084",
		"value": "Z4575"
	  },
	  {
		"use": "usual",
		"type": {
		  "text": "FHIR"
		},
		"system": "http://open.epic.com/FHIR/StructureDefinition/patient-dstu2-fhir-id",
		"value": "T81lum-5p6QvDR7l6hv7lfE52bAbA2ylWBnv9CZEzNb0B"
	  },
	  {
		"use": "usual",
		"type": {
		  "text": "FHIR STU3"
		},
		"system": "http://open.epic.com/FHIR/StructureDefinition/patient-fhir-id",
		"value": "e63wRTbPfr1p8UW81d8Seiw3"
	  },
	  {
		"use": "usual",
		"type": {
		  "text": "INTERNAL"
		},
		"system": "urn:oid:1.2.840.114350.1.13.0.1.7.2.698084",
		"value": "Z4575"
	  },
	  {
		"use": "usual",
		"type": {
		  "text": "EPI"
		},
		"system": "urn:oid:1.2.840.114350.1.13.0.1.7.5.737384.14",
		"value": "202500"
	  },
	  {
		"use": "usual",
		"type": {
		  "text": "MYCHARTLOGIN"
		},
		"system": "urn:oid:1.2.840.114350.1.13.0.1.7.3.878082.110",
		"value": "MYCHARTTEDDY"
	  },
	  {
		"use": "usual",
		"type": {
		  "text": "WPRINTERNAL"
		},
		"system": "urn:oid:1.2.840.114350.1.13.0.1.7.2.878082",
		"value": "19"
	  },
	  {
		"use": "usual",
		"system": "https://open.epic.com/FHIR/StructureDefinition/PayerMemberId",
		"value": "530002010"
	  },
	  {
		"use": "usual",
		"system": "https://open.epic.com/FHIR/StructureDefinition/PayerMemberId",
		"value": "A0296438559"
	  }
	],
	"active": true,
	"name": [
	  {
		"use": "official",
		"text": "Mr. Theodore Mychart",
		"family": "Mychart",
		"given": [
		  "Theodore"
		],
		"prefix": [
		  "MR."
		]
	  },
	  {
		"use": "usual",
		"text": "Mr. Theodore Mychart",
		"family": "Mychart",
		"given": [
		  "Theodore"
		],
		"prefix": [
		  "MR."
		]
	  }
	],
	"telecom": [
	  {
		"system": "phone",
		"value": "608-213-5806",
		"use": "home"
	  },
	  {
		"system": "phone",
		"value": "608-272-5000",
		"use": "work"
	  }
	],
	"gender": "male",
	"birthDate": "1948-07-07",
	"deceasedBoolean": false,
	"address": [
	  {
		"use": "old",
		"line": [
		  "134 Elm Street"
		],
		"city": "Madison",
		"state": "WI",
		"postalCode": "53706",
		"country": "US"
	  },
	  {
		"use": "home",
		"line": [
		  "134 Elm Street"
		],
		"city": "Madison",
		"state": "WI",
		"postalCode": "53706",
		"country": "US"
	  }
	],
	"maritalStatus": {
	  "text": "Married"
	},
	"contact": [
	  {
		"relationship": [
		  {
			"coding": [
			  {
				"system": "urn:oid:1.2.840.114350.1.13.0.1.7.4.827665.1000",
				"code": "14",
				"display": "Sister"
			  }
			],
			"text": "Sister"
		  }
		],
		"name": {
		  "use": "usual",
		  "text": "Sally Tonga"
		},
		"telecom": [
		  {
			"system": "phone",
			"value": "608-921-8342",
			"use": "home"
		  }
		]
	  },
	  {
		"relationship": [
		  {
			"coding": [
			  {
				"system": "http://terminology.hl7.org/CodeSystem/v2-0131",
				"code": "E",
				"display": "Employer"
			  }
			]
		  }
		],
		"organization": {
		  "display": "Ehs Generic Employer"
		}
	  }
	],
	"generalPractitioner": [
	  {
		"reference": "Practitioner/eM5CWtq15N0WJeuCet5bJlQ3",
		"type": "Practitioner",
		"display": "Physician Family Medicine, MD"
	  }
	],
	"managingOrganization": {
	  "reference": "Organization/enRyWnSP963FYDpoks4NHOA3",
	  "display": "Epic Hospital System"
	}
  }

{% endmacro %}

{% macro data_patient_birth_sex_extension() %}
{
	"resourceType": "Patient",
	"id": "test",
	"gender": "female",
	"extension": [{
		"valueCode": "M",
		"url": "http://hl7.org/fhir/us/core/StructureDefinition/us-core-birthsex"
	}]
}
{% endmacro %}

{% macro data_patient_sex_for_clinical_use_extension() %}
{
	"resourceType": "Patient",
	"id": "example",
	"gender": "female",
	"extension": [{
		"valueCodeableConcept": {
		  "coding": [{
				"system": "urn:oid:1.2.840.114350.1.13.0.1.7.10.698084.130.657370.19999000",
				"code": "male",
				"display": "male"
			}]
		},
		"url": "http://open.epic.com/FHIR/StructureDefinition/extension/sex-for-clinical-use"
	},{
		"valueCode": "F",
		"url": "http://hl7.org/fhir/us/core/StructureDefinition/us-core-birthsex"
	}]
}
{% endmacro %}

{% macro data_patient_no_sex_extension() %}
{
	"resourceType": "Patient",
	"id": "example",
	"gender": "male"
}
{% endmacro %}

{% macro data_patient_us_core_race_ethnicity() %}
{
  "resourceType": "Patient",
  "id": "example",
  "extension": [
    {
      "extension": [
        {
          "url": "ombCategory",
          "valueCoding": {
            "system": "urn:oid:2.16.840.1.113883.6.238",
            "code": "2106-3",
            "display": "White"
          }
        },
        {
          "url": "ombCategory",
          "valueCoding": {
            "system": "urn:oid:2.16.840.1.113883.6.238",
            "code": "1002-5",
            "display": "American Indian or Alaska Native"
          }
        },
        {
          "url": "ombCategory",
          "valueCoding": {
            "system": "urn:oid:2.16.840.1.113883.6.238",
            "code": "2028-9",
            "display": "Asian"
          }
        },
        {
          "url": "detailed",
          "valueCoding": {
            "system": "urn:oid:2.16.840.1.113883.6.238",
            "code": "1586-7",
            "display": "Shoshone"
          }
        },
        {
          "url": "detailed",
          "valueCoding": {
            "system": "urn:oid:2.16.840.1.113883.6.238",
            "code": "2036-2",
            "display": "Filipino"
          }
        },
        {
          "url": "text",
          "valueString": "Mixed"
        }
      ],
      "url": "http://hl7.org/fhir/us/core/StructureDefinition/us-core-race"
    },
    {
      "extension": [
        {
          "url": "ombCategory",
          "valueCoding": {
            "system": "urn:oid:2.16.840.1.113883.6.238",
            "code": "2135-2",
            "display": "Hispanic or Latino"
          }
        },
        {
          "url": "detailed",
          "valueCoding": {
            "system": "urn:oid:2.16.840.1.113883.6.238",
            "code": "2184-0",
            "display": "Dominican"
          }
        },
        {
          "url": "detailed",
          "valueCoding": {
            "system": "urn:oid:2.16.840.1.113883.6.238",
            "code": "2148-5",
            "display": "Mexican"
          }
        },
        {
          "url": "text",
          "valueString": "Hispanic or Latino"
        }
      ],
      "url": "http://hl7.org/fhir/us/core/StructureDefinition/us-core-ethnicity"
    },
    {
      "url": "http://hl7.org/fhir/us/core/StructureDefinition/us-core-birthsex",
      "valueCode": "F"
    }
  ]
}
{% endmacro %}

{% macro test_flatten_patient_use_best_gender() %}

WITH fhir_1 AS (
	{{ import_json( data_patient_sex_for_clinical_use_extension() ) }}
),
flat_1 AS (
	{{ flat_patient('fhir_1', 'resource') }}
),
fhir_2 AS (
  {{ import_json( data_patient_birth_sex_extension() ) }}
),
flat_2 AS (
	{{ flat_patient('fhir_2', 'resource') }}
),
fhir_3 AS (
  {{ import_json( data_patient_no_sex_extension() ) }}
),
flat_3 AS (
	{{ flat_patient('fhir_3', 'resource') }}
),
result AS (
	SELECT * FROM flat_1
	WHERE flat_1.sex = 'male'
	UNION ALL
	SELECT * FROM flat_2
	WHERE flat_2.sex = 'male'
	UNION ALL
	SELECT * FROM flat_3
	WHERE flat_3.sex = 'male'
)
SELECT 3
EXCEPT
SELECT count(*) FROM result

{% endmacro %}

{% macro test_flatten_patient_deceased_choices() %}
WITH fhir_1 AS (
	{{ import_json( '{"deceasedDateTime": "2020-01-01"}' ) }}
),
flat_1 AS (
	{{ flat_patient('fhir_1', 'resource') }}
),
fhir_2 AS (
  {{ import_json( '{"deceasedBoolean": true}' ) }}
),
flat_2 AS (
	{{ flat_patient('fhir_2', 'resource') }}
),
result AS (
	SELECT * FROM flat_1
	WHERE flat_1.is_deceased = true
	UNION ALL
	SELECT * FROM flat_2
	WHERE flat_2.is_deceased = true
)
SELECT 2
EXCEPT
SELECT count(*) FROM result
{% endmacro %}

{% macro test_flatten_patient_race() %}

WITH fhir AS (
  {{ import_json( data_patient_us_core_race_ethnicity() ) }}
),
flat AS (
	{{ flat_patient('fhir', 'resource') }}
)
SELECT '1002-5,2028-9,2106-3'
EXCEPT
SELECT omb_race_code FROM flat

{% endmacro %}

{% macro test_flatten_patient_ethnicity() %}
WITH fhir AS (
{{ import_json( data_patient_us_core_race_ethnicity() ) }}
),
flat AS (
	{{ flat_patient('fhir', 'resource') }}
)
SELECT '2135-2'
EXCEPT
SELECT omb_ethnicity_code FROM flat
{% endmacro %}

{% macro test_flatten_patient_epic() %}
WITH fhir AS (
  {{ import_json( data_patient_epic() ) }}
),
flat AS (
	{{ flat_patient('fhir', 'resource') }}
),
expect AS (
	{% call table_to_sql() %}
	| id                         | active   | is_deceased   | birth_date          | death_date   |  sex    | omb_race_code   | omb_ethnicity_code   |
	|----------------------------|----------|---------------|---------------------|--------------|---------|-----------------|----------------------|
	| 'e63wRTbPfr1p8UW81d8Seiw3' | True     | False         | '1948-07-07' | NULL         |  'male' | '2106-3'        | NULL                 |
	{% endcall %}
)

{{ compare_tables("expect", "flat") }}

{% endmacro %}

{% macro test_flatten_patient_simple() %}

WITH fhir AS (
  {{ import_json( data_patient_no_extensions() ) }}
),
flat AS (
	{{ flat_patient('fhir', 'resource') }}
),
expect AS (
	{% call table_to_sql() %}
| id                         | active::BOOLEAN   | is_deceased::BOOLEAN   | birth_date   | death_date   | sex    | omb_race_code   | omb_ethnicity_code   |
|----------------------------|----------|---------------|--------------|--------------|--------|-----------------|----------------------|
| 'e63wRTbPfr1p8UW81d8Seiw3' | NULL     | NULL          | '1948-07-07' | NULL         | 'male' | NULL            | NULL                 |
  {% endcall %}
)

{{ compare_tables("expect", "flat")}}

{% endmacro %}