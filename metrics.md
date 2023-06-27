# Qualifier Metrics

> **Note**
> This metric set represents an early draft and metrics will be updated, added, and removed based on feedback from implementers and the FHIR community.

## Overview

The metrics outlined below are focused on evaluating the data quality and characteristics of data sets that comply with the [FHIR](https://hl7.org/fhir/) [USCDI v1](https://www.healthit.gov/isa/united-states-core-data-interoperability-uscdi) data subset as described in the [FHIR US Core STU4 Implementation Guide](http://hl7.org/fhir/us/core/STU4/) (IG) implemented by current EHR systems.

## Draft Metrics - Data Quality

### `q_obs_value_range` [plausibility] Expect Quantitative Observation Value to be in Plausible Range

Denominator resource inclusion:
- `Observation.valueQuantity` element is populated 
- `Observation.code` matches a code with a plausibility range in the [OHDSI Data Quality Dashboard definitions](https://github.com/OHDSI/DataQualityDashboard/blob/main/inst/csv/OMOP_CDMv5.3.1_Concept_Level.csv)
- `Observation.valueQuantity.system` is UCUM and `Observation.valueQuantity.code` is populated

Numerator resource inclusion:
- `Observation.valueQuantity` element value is above or below the range defined in the [OHDSI Data Quality Dashboard definitions](https://github.com/OHDSI/DataQualityDashboard/blob/main/inst/csv/OMOP_CDMv5.3.1_Concept_Level.csv)

### `q_obs_comp_value_range` [plausibility] Expect Quantitative Observation _Component_ Value to be in Plausible Range

Denominator resource inclusion:
- `Observation.component.valueQuantity` element is populated 
- `Observation.component.valueQuantity.system` is UCUM and `Observation.component.valueQuantity.code` is populated
- `Observation.component.code` matches a code with a plausibility range in the [OHDSI Data Quality Dashboard definitions](https://github.com/OHDSI/DataQualityDashboard/blob/main/inst/csv/OMOP_CDMv5.3.1_Concept_Level.csv)

Numerator resource inclusion:
- `Observation.component.valueQuantity` element value is above or below the range defined in the [OHDSI Data Quality Dashboard definitions](https://github.com/OHDSI/DataQualityDashboard/blob/main/inst/csv/OMOP_CDMv5.3.1_Concept_Level.csv)

### `q_cond_gender` [plausibility] Expect Condition Gender to be Plausible

Notes:
- The FHIR Patient.gender element represents administrative gender which is not ideal for this purpose. USCDI v2 requires a `us-core-birthsex` extension, though this will be changing in v3 based on feedback from the clinical community. Epic supports inclusion of a `sex-for-clinical-use` extension, though it is unclear how often this is populated in production implementations. Qualifier will use the Epic extension preferentially, falling back to the birth sex extension and then administrative gender.

Denominator resource inclusion:
- `Condition.code` matches a code with a plausible gender in the [OHDSI Data Quality Dashboard definitions](https://github.com/OHDSI/DataQualityDashboard/blob/main/inst/csv/OMOP_CDMv5.3.1_Concept_Level.csv)
- `Condition.patient` is populated with a reference to a Patient resource in the dataset

Numerator resource inclusion:
- Patient gender does not match the plausible gender for the condition code defined in the [OHDSI Data Quality Dashboard definitions](https://github.com/OHDSI/DataQualityDashboard/blob/main/inst/csv/OMOP_CDMv5.3.1_Concept_Level.csv)


### `q_proc_gender` [plausibility] Expect Procedure Gender to be Plausible

Notes:
- See `q_cond_gender` for details on how Patient gender is derived

Denominator resource inclusion:
- `Procedure.code` matches a code with a plausible gender in the [OHDSI Data Quality Dashboard definitions](https://github.com/OHDSI/DataQualityDashboard/blob/main/inst/csv/OMOP_CDMv5.3.1_Concept_Level.csv)
- `Procedure.patient` is populated with a reference to a Patient resource in the dataset

Numerator resource inclusion:
- Patient gender does not match the plausible gender defined for this procedure code in the [OHDSI Data Quality Dashboard definitions](https://github.com/OHDSI/DataQualityDashboard/blob/main/inst/csv/OMOP_CDMv5.3.1_Concept_Level.csv)

### `q_date_sequence` [plausibility] Expect Date to be in Plausible Sequence

Date sequence pairs:

| Resource  Type     | Date Element                       | Subsequent Resource Type | Subsequent Date Element                  |
|--------------------|------------------------------------|--------------------------|------------------------------------------|
| Patient            | birthDate                          | Patient                  | deceasedDateTime                         |
| Condition          | onsetPeriod.start OR onsetDateTime | Condition                | abatementDateTime OR abatementPeriod.end |
| Condition          | onsetPeriod.start OR onsetDateTime | Condition                | recordedDate                             |
| Encounter          | period.start                       | Encounter                | period.end                               |
| Immunization       | occurrenceDateTime                 | Immunization             | recorded                                 |
| AllergyIntolerance | onsetPeriod.start                  | AllergyIntolerance       | onsetPeriod.end                          |
| AllergyIntolerance | onsetPeriod.start                  | AllergyIntolerance       | recordedDate                             |
| MedicationRequest  | authoredOn                         | MedicationAdministration | effectiveDateTime                        |

Denominator resource inclusion:
- Both elements in a date sequence pair are populated

Numerator resource inclusion:
- Subsequent Date listed in the date sequence pair is earlier than the Date Element (both date elements may be the same)

Notes:
- Partial date elements are interpreted as the earliest date possible (e.g., 1999 would be the equivalent of 1999-01-01)
- Partial Subsequent Date elements are interpreted as the latest date possible (e.g., 1999 would be the equivalent of 1999-12-31)

### `q_date_in_lifetime` [plausibility] Expect Date to be During Patient Life

Date elements:

| Resource Type            | Date Element                                                                           |
|--------------------------|----------------------------------------------------------------------------------------|
| Observation              | effectiveDateTime                                                                      |
| Condition                | recordedDate, onsetDateTime, onsetPeriod.start, abatementDateTime, abatementPeriod.end |
| Encounter                | period.start                                                                           |
| Immunization             | occurrenceDateTime                                                                     |
| Procedure                | performedDateTime, performedPeriod.start                                               |
| AllergyIntolerance       | recordedDate, onsetDateTime, onsetPeriod.start, onsetPeriod.end                        |
| DocumentReference        | date                                                                                   |
| MedicationRequest        | authoredOn                                                                             |
| MedicationAdministration | effectiveDateTime                                                                      |

Parameters:
- `threshold_days` - allowed period after death date, defaults to 30 days

Denominator resource inclusion:
- `Patient.birthDate` is populated along with a date from the date elements table
- Reference from the resource to a Patient resource in the dataset

Numerator resource inclusion:
- `Patient.birthDate` is after a date in the data elements table or `Patient.deceasedDateTime` is populated and a date in the date elements table is more than `threshold_days` after the `Patient.deceasedDateTime`

Notes:
- Partial birthDate elements are interpreted as the earliest timestamp possible (e.g., 1999 would be the equivalent of 1999-01-01)
- Partial date elements are interpreted as the latest date possible when compared to birthDate (e.g., 1999 would be the equivalent of 1999-12-31)
- Partial date elements are interpreted as the earliest date possible when compared to deceasedDateTime (e.g., 1999 would be the equivalent of 1999-01-01)

### `q_date_recent` [plausibility] Expect Date to be in Recent Past

Notes:
- Same date elements set as `q_date_lifetime` above

Parameters:
- `run_time` - the start datatime when the set of queries that includes this metric was run
- `start_date` - defaults to `1950-01-01` (kind of arbitrary, but it's what OMOP is using)
- `end_date` - defaults to metric run time plus 0 days

Denominator resource inclusion:
- Date from the date elements table in `q_date_lifetime` is populated

Numerator resource inclusion:
- Date from the date elements table in `q_date_lifetime` is before `start_date` parameter and/or after `end_date` parameter

Notes:
- Partial date elements are interpreted as the latest date possible when compared to start_date (e.g., 1999 would be the equivalent of 1999-12-31)
- Partial date elements are interpreted as the earliest date possible when compared to end_date (e.g., 1999 would be the equivalent of 1999-01-01)

### `q_obs_unit` [plausibility] Expect Quantitative Observation Value to Match Common Units

Denominator resource inclusion:
- `Observation.valueQuantity` element is populated 
- `Observation.code` matches a LOINC code with an example unit in the [LOINC database](https://loinc.org/kb/users-guide/loinc-database-structure/#:~:text=example_ucum_units)

Numerator resource inclusion:
- `Observation.valueQuantity.system` is UCUM (`http://unitsofmeasure.org`) and `Observation.valueQuantity.code` is populated
- `Observation.valueQuantity.code` element does not match a unit in the example unit set for any of the LOINC codes in the `Observation.code` element. The unit set is computed by grouping UCUM units by type (e.g., volume measures, size measures) and using these groups to expand the sample unit listed in the LOINC database.

### `q_obs_comp_unit` [plausibility] Expect Quantitative Observation Component Value to Match Common Units

Denominator resource inclusion:
- `Observation.component.valueQuantity` element is populated 
- `Observation.componet.code` matches a LOINC code with an example unit set in the [LOINC database](https://loinc.org/kb/users-guide/loinc-database-structure/#:~:text=example_ucum_units)
- `Observation.component.valueQuantity.system` is ucum (`http://unitsofmeasure.org`) and `Observation.component.valueQuantity.code` is populated

Numerator resource inclusion:
- `Observation.component.valueQuantity.code` element is not contained in the example unit set for at least one of the LOINC codes in the `Observation.component.code` element

### `q_value_unique` [conformance] Expect Element Value to be Unique

Denominator resource inclusion:
- Resource Type is one of the following: Patient, Observation, Condition, Procedure, Immunization, AllergyIntolerance, DocumentReference, MedicationRequest, Medication, MedicationAdministration, Device

Numerator resource inclusion:
- Resource `id` element has the same value for more than one resource of a single Resource Type
- The `meta.versionId` element is not populated for these resources or has the same value in more than one resource

Notes:
- Users may add wish to add other elements to this query which can serve as a base

### `q_term_use` [conformance] Expect Common Terminology Systems to be Populated

Coded elements:

| Resource Type            | Element                   | System                                      | System [OID](https://www.hl7.org/fhir/terminologies-systems.html) |
|--------------------------|---------------------------|---------------------------------------------|-------------------------------------------------------------------|
| Observation              | code                      | http://loinc.org                            | 2.16.840.1.113883.6.1                                             |
| Observation              | valueCodeableConcept      | http://snomed.info/sct                      | 2.16.840.1.113883.6.96                                            |
| Condition                | code                      | http://snomed.info/sct                      | 2.16.840.1.113883.6.96                                            |
| Procedure                | code                      | http://www.ama-assn.org/go/cpt              | 2.16.840.1.113883.6.12                                            |
| Immunization             | code                      | http://hl7.org/fhir/sid/cvx                 | 2.16.840.1.113883.12.292                                          |
| AllergyIntolerance       | code                      | http://snomed.info/sct                      | 2.16.840.1.113883.6.96                                            |
| DocumentReference        | type                      | http://loinc.org                            | 2.16.840.1.113883.6.1                                             |
| MedicationRequest        | medicationCodeableConcept | http://www.nlm.nih.gov/research/umls/rxnorm | 2.16.840.1.113883.6.88                                            |
| Medication               | code                      | http://www.nlm.nih.gov/research/umls/rxnorm | 2.16.840.1.113883.6.88                                            |
| MedicationAdministration | medicationCodeableConcept | http://www.nlm.nih.gov/research/umls/rxnorm | 2.16.840.1.113883.6.88                                            |
| Device                   | type                      | http://snomed.info/sct                      | 2.16.840.1.113883.6.96                                            |

Parameters:
- `skip_elements` - Array of strings in the form of `{resource}.{element}`

Denominator resource inclusion:
- Resource type is in coded elements list and has at least one element that is not in the `skip_elements` parameter

Numerator resource inclusion:
- Element in coded elements list does not have at least one value populated with the system specified in the elements list

### `q_ref_target_pop` [conformance] Expect Reference Target to be Populated

Reference targets:

| Resource Type            | Element | Target Type |
|--------------------------|---------|-------------|
| Observation              | subject | Patient     |
| Condition                | patient | Patient     |
| Procedure                | patient | Patient     |
| Immunization             | patient | Patient     |
| AllergyIntolerance       | patient | Patient     |
| DocumentReference        | subject | Patient     |
| MedicationRequest        | subject | Patient     |
| MedicationAdministration | subject | Patient     |
| Device                   | patient | Patient     |

Parameters:
- `skip_elements` - Array of strings in the form of `{resource}.{element}`

Denominator resource inclusion:
- Resource type is in reference targets list

Numerator resource inclusion:
- Element in reference target list does not have at least one reference that has a target with the url for a resource of the specified type

### `q_ref_target_valid` [completeness] Expect Reference Target to be Resolvable when Populated

Reference targets:

| Resource Type            | Element   | Target Type |
|--------------------------|-----------|-------------|
| Observation              | subject   | Patient     |
| Observation              | encounter | Encounter   |
| Condition                | patient   | Patient     |
| Condition                | encounter | Encounter   |
| Procedure                | patient   | Patient     |
| Procedure                | encounter | Encounter   |
| Immunization             | patient   | Patient     |
| Immunization             | encounter | Encounter   |
| AllergyIntolerance       | patient   | Patient     |
| AllergyIntolerance       | encounter | Encounter   |
| DocumentReference        | subject   | Patient     |
| DocumentReference        | encounter | Encounter   |
| MedicationRequest        | subject   | Patient     |
| MedicationRequest        | encounter | Encounter   |
| MedicationAdministration | subject   | Patient     |
| MedicationAdministration | encounter | Encounter   |
| DocumentReference        | subject   | Patient     |
| DocumentReference        | encounter | Encounter   |
| Device                   | patient   | Patient     |

Parameters:
- `skip_elements` - Array of strings in the form of `{resource}.{element}`

Denominator resource inclusion:
- Resource type is in reference targets list

Numerator resource inclusion:
- Each element in reference target list does not have at least one reference that resolves to a resource of the specified type within the dataset being characterized

### `q_element_present` [completeness] Expect Element to be Populated

Notes:
- This overlaps with profile validation - worth keeping?
- Auto generate from US Core required elements (maybe with warnings on unpopulated "must support" elements)?

## Draft Metrics - Data Characterization

### `c_resource_count` [volume] Count of Unique Resources by Resource Type (by category, by year, by month)

Notes:
- The resource `meta.lastUpdated` date has proven unreliable in many EHR implementations or is omitted entirely (e.g., in Epic). Instead, the  date fields in the date elements list below are used when the date stratification is applied

Date elements:
	
| Resource Type            | Date Stratification Element                        |
|--------------------------|----------------------------------------------------|
| Patient                  | NA                                                 |
| Observation              | effectiveDateTime                                  |
| Condition                | recordedDate OR onsetDateTime OR onsetPeriod.start |
| Encounter                | period.start                                       |
| Immunization             | occurrenceDateTime                                 |
| Procedure                | performedDateTime OR performedPeriod.start         |
| AllergyIntolerance       | recordedDate OR onsetDateTime OR onsetPeriod.start |
| DocumentReference        | date                                               |
| MedicationRequest        | authoredOn                                         |
| Medication               | NA                                                 |
| MedicationAdministration | effectiveDateTime                                  |
| Device (implantable)     | NA                                                 |

Category elements:
	
| Resource Type            | Category Stratification Element | Category System                                                           |
|--------------------------|---------------------------------|---------------------------------------------------------------------------|
| Patient                  | NA                              | NA                                                                        |
| Observation              | category                        | http://terminology.hl7.org/CodeSystem/observation-category                |
| Condition                | category                        | http://terminology.hl7.org/CodeSystem/condition-category                  |
| Encounter                | type                            | http://www.ama-assn.org/go/cpt or http://snomed.info/sct                  |
| Immunization             | NA                              | NA                                                                        |
| Procedure                | NA                              | NA                                                                        |
| AllergyIntolerance       | category                        | food, medication, environment, biologic                                   |
| DocumentReference        | category                        | http://hl7.org/fhir/us/core/CodeSystem/us-core-documentreference-category |
| MedicationRequest        | category                        | http://terminology.hl7.org/CodeSystem/medicationrequest-category          |
| Medication               | NA                              | NA                                                                        |
| MedicationAdministration | NA                              | NA                                                                        |
| Device (implantable)     | NA                              | NA                                                                        |
 
### `c_pt_count` [demographics] Count of Patients (by birth year, by gender, by ethnicity, by race)

Notes:
- `valueCoding` from `us-core-race/ombCategory` extension is used for race and `valueCoding` from the `us-core-ethnicity/ombCategory` extension is used for ethnicity, concatenating the sorted values if there are multiple races listed for an individual patient

### `c_pt_deceased_count` [demographics] Count of Deceased Patients (by gender, by age at death)

Notes:
- Patients with a `deceasedBoolean` element populated as `true` are included in the query results with a deceased age of `NULL`

### `c_pt_zipcode_count` [demographics] Count of Patients By Zip Code (3 digit)

Notes:
- Only include an address if country is USA or no country is populated and the `address.postalCode` element matches a US zip code pattern (five digits with an optional four digits following a dash)
- Exclude the set of [sparsely populated](https://www.johndcook.com/blog/2016/06/29/sparsely-populated-zip-codes/) 3 digit zip codes to be HIPAA compliant, replacing them with `000`
- Prefer `use=home`, `type=physical` or `both`, and a period without an end date. Fallback order for `address.use` element is `temp`, `work`, `billing`, any

### `c_term_coverage` [terminology] Count of Resources by Terminology System (by resource type, by category)

Notes:
- For CodeableConcept elements, return the count of resources that can be retrieved with each combination of the terminology systems being used (e.g., count of Procedure resources that have a SNOMED CT, count that have an ICD-10 code, and count with either a SNOMED CT code or ICD-10 code since systems may partially overlap).
- For each element and combination of systems, return the count of resources that also have a text description of the concept.
- This metric will point to the best set of terminology systems to be used when querying the population, and/or highlight terminology mappings that should be adjusted in the source system or through a transformation step in a data pipeline to improve queryability for specific use cases.

| Resource Type             | CodeableConcept Element   |
|---------------------------|---------------------------|
| Observation (by category) | code                      |
| Condition (by category)   | code                      |
| Encounter                 | type                      |
| Procedure                 | code                      |
| Immunization              | vaccineCode               |
| AllergyIntolerance        | code                      |
| DocumentReference         | type                      |
| MedicationRequest         | medicationCodeableConcept |
| MedicationAdministration  | medicationCodeableConcept |
| Device                    | type                      |

### `c_identifier_coverage` [terminology] Count of Resources by Identifier System (by resource type)

Notes:
- For Identifier elements, return the count of resources that can be retrieved with each combination of the identifier systems being used (e.g., count of patient resources that have a MRN from EHR #1, count that have a MRN from EHR #2, and count with either of those as occurrences may partially overlap).
- This metric will indicate which identifier systems will be available to match patients and encounters with those in other data extracts.


| Resource Type | Identifier Element |
|---------------|--------------------|
| Patient       | identifier         |
| Encounter     | identifier         |

### `c_term_use` [terminology] Count of Resources by Coded Value (by resource type, by category, by element, by system, by code)

Notes:
- More complete exploration of elements not included here can be done with the open source [FHIR Data Census Tool](https://github.com/sync-for-science/data-census)

| Resource Type             | Elements                                                                                                |
|---------------------------|---------------------------------------------------------------------------------------------------------|
| Patient                   | _identifier_ (system only to avoid leaking PHI), address.use, address.type, telecom.system, telecom.use |
| Observation (by category) | _code_, valueCodeableConcept, status                                                                    |
| Condition (by category)   | _code_, clinicalStatus, verificationStatus, severity                                                    |
| Encounter                 | type, reasonCode, dischargeDisposition                                                                  |
| Procedure                 | _code_, category, status                                                                                |
| Immunization              | _vaccineCode_, status                                                                                   |
| AllergyIntolerance        | _code_, verificationStatus, reaction.manifestation, reaction.severity                                   |
| DocumentReference         | _type_, docStatus, status, contentType                                                                  |
| MedicationRequest         | _medicationCodeableConcept_, medicationReference.code intent, status, reported                          |
| MedicationAdministration  | _medicationCodeableConcept_, status                                                                     |
| Device                    | _type_, status                                                                                          |

Parameters:
- `skip_elements` - array of '{resource}.{element}' strings with one or more items from the list above

### `c_term_use_pt` [terminology] Count of Patients per Coded Value (by resource type, by category, by element, by system, by code)

Notes:
- See coded values in `c_term_use`

### `c_term_use_panel` [terminology] Count of Coded Laboratory  Panel Components (by panel system, by panel code, by component system, by component code)

Notes:
- Count of `Observation.code` values that are referenced from a `DiagnosticReport.results` array 
- Looks like this may be possible in Epic, though Cerner doesn't seem to have support for DiagnosticReport resources yet based on https://groups.google.com/g/cerner-fhir-developers/c/Pn1HnUMwcCo/m/MSaguilDAAAJ 

### `c_term_first_use` [terminology] Count of Earliest Use of Coded Value (by resource type, by category, by element, by system, by code, by year, by month)

Notes:
- See code elements in `c_term_use`
- See date elements in `c_resource_count`

### `c_term_last_use` [terminology] Count of Latest Use of Coded Value (by resource type, by category, by element, by system, by code, by year, by month)

Notes:
- See code elements in `c_term_use`
- See date elements in `c_resource_count`

### `c_resources_per_pt` [volume] Distribution of Unique Resources per Patient (by resource type, by category)

Notes:
- See categories defined for `c_resource_count` 

### `c_element_use` [volume] Count of Resources with Element Populated

Notes:
- Used to verify population of elements needed for specific types of analysis that are not covered by other metrics. More complete exploration can be done with the open source [FHIR Data Census Tool](https://github.com/sync-for-science/data-census).
- This is kind of a catch-all metric, might be worth removing, but could also be useful to researchers as a base to add their own elements of interest? 

| Resource Type     | Element                                                            |
|-------------------|--------------------------------------------------------------------|
| Observation       | dataAbsentReason, valueQuantity, valueCodeableConcept, valueString |
| Condition         | onsetPeriod.start, onsetDateTime                                   |
| DocumentReference | context.encounter.reference, context.period.start                  |


### `c_record_first` [temporality] Distribution of Earliest Patient Record (by year, by month) 

Notes:
- Record defined as earliest of `Encounter`, `Observation`, or `MedicationRequest` resource
- See date elements in `c_resource_count`

### `c_record_last` [temporality] Distribution of Latest Patient Record (by year, by month) 

Notes:
- Record defined as earliest of `Encounter`, `Observation`, or `MedicationRequest` resource
- See date elements in `c_resource_count`

### `c_enc_duration` [temporality] Distribution of Encounter Duration (by encounter type)

Notes:
- Length defined as number of days between `Encounter.period.start` and `Encounter.period.end`
- A start and end date must be populated for a resource to be included in this metric

### `c_first_enc_age` [demographics] Distribution of Patients By Age at First Encounter (by gender)

Notes:
- Age is based on `Patient.birthDate` element
- First encounter is based on `Encounter.period.start`

### `c_diagnosis_prevalence` [condition] Count of Patients with Documented Disease (by gender, by condition code)

Notes:
- Include patients who have a condition where `Condition.code` that matches a code with a prevalence range in the [OHDSI Data Quality Dashboard definitions](https://github.com/OHDSI/DataQualityDashboard/blob/main/inst/csv/OMOP_CDMv5.3.1_Concept_Level.csv) 

### `c_diagnosis_support` [condition] Percentage of Problem List Items with Supporting Observations (by condition, by year, by month)

Notes:
- This would require clinical input to develop, but the idea is to identify SNOMED codes that could be supported by Observations based on LOINC codes and values. For example, a diabetes / pre-diabetes dx with supporting A1C values, an obesity dx with supporting BMI data, or a hypertension / pre-hypertension dx with supporting bp data. 
- Stratification by condition dates listed in `c_resource_count` to address changes in documentation patterns over time

### `c_date_precision` [structure] Distribution of Resource Count by DateTime Element Precision (by resource type, by category, by date element, by precision level)

Date elements:
	
| Resource Type            | Date Element                                                                                                                   |
|--------------------------|--------------------------------------------------------------------------------------------------------------------------------|
| Patient                  | birthDate, deceasedDateTime                                                                                                    |
| Observation              | effectiveDateTime                                                                                                              |
| Condition                | recordedDate, onsetDateTime, onsetPeriod.start, onsetPeriod.end, abatementDateTime, abatementPeriod.start, abatementPeriod.end |
| Encounter                | period.start, period.end                                                                                                       |
| Immunization             | occurrenceDateTime                                                                                                             |
| Procedure                | performedDateTime, performedPeriod.start                                                                                       |
| AllergyIntolerance       | recordedDate, onsetDateTime, onsetPeriod.start, onsetPeriod.end                                                                |
| MedicationRequest        | authoredOn                                                                                                                     |
| MedicationAdministration | effectiveDateTime                                                                                                              |
| Device (implantable)     | manufactureDate, expirationDate                                                                                                |
| DiagnosticReport         | effectiveDateTime                                                                                                              |

Notes:
- `DateTime` element precision levels are `year` (YYYY), `month` (YYYY-MM), `day` (YYYY-MM-DD), `time-seconds` (YYYY-MM-DDThh:mm:ss+zz:zz), and `time-milliseconds` (YYYY-MM-DDThh:mm:ss.fff+zz:zz)
- `Date` element precision levels are the same with the exception of `time-seconds` or `time-milliseconds`

### `c_choice_type_populated` [structure] Distribution of Resource Count by Choice Type Element Populated (by resource type, by category, by choice element, by choice type)

Choice elements:

| Resource Type      | Element       | Choices                                                                             |
|--------------------|---------------|-------------------------------------------------------------------------------------|
| Patient            | deceased[x]   | deceasedDateTime, deceasedBoolean                                                   |
| Observation        | value[x]      | valueQuantity, valueCodeableConcept, valueString, component.valueQuantity           |
| Condition          | onset[x]      | onsetDateTime, onsetPeriod, onsetRange, onsetString, onsetAge                       |
| Condition          | abatement[x]  | abatementDateTime, abatementPeriod, abatementRange,  abatementString,  abatementAge |
| AllergyIntolerance | onset[x]      | onsetDateTime, onsetPeriod, onsetRange, onsetString, onsetAge                       |
| MedicationRequest  | medication[x] | medicationCodeableConcept, medicationReference                                      |
| MedicationRequest  | reported[x]   | reportedBoolean reportedReference                                                   |
| DiagnosticReport   | effective[x]  | effectiveDateTime, effectivePeriod                                                  |

Notes:
- These are the choice fields in US Core, but could use the FHIR definitions to create a full list, or could do a more general query based on JSON key prefix (not supported by all databases and potentially slow even where supported)
