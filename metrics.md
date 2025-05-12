# Qualifier Metrics

> **Note**
> This metric set represents an early draft and metrics will be updated, added, and removed based on feedback from implementers and the FHIR community.

## Overview

The metrics outlined below are focused on evaluating the data quality and characteristics of data sets that comply with the [FHIR](https://hl7.org/fhir/) [USCDI v1](https://www.healthit.gov/isa/united-states-core-data-interoperability-uscdi) data subset as described in the [FHIR US Core STU4 Implementation Guide](http://hl7.org/fhir/us/core/STU4/) (IG) implemented by current EHR systems.

## Draft Metrics - Data Quality

### q_obs_value_range
**[plausibility]** Expect Quantitative Observation Value to be in Plausible Range

Denominator resource inclusion:
- `Observation.valueQuantity` element is populated 
- `Observation.code` matches a code with a plausibility range in the [OHDSI Data Quality Dashboard definitions](https://github.com/OHDSI/DataQualityDashboard/blob/main/inst/csv/OMOP_CDMv5.4_Concept_Level.csv)
- `Observation.valueQuantity.system` is UCUM and `Observation.valueQuantity.code` is populated

Numerator resource inclusion:
- `Observation.valueQuantity` element value is above or below the range defined in the [OHDSI Data Quality Dashboard definitions](https://github.com/OHDSI/DataQualityDashboard/blob/main/inst/csv/OMOP_CDMv5.4_Concept_Level.csv)

### q_obs_comp_value_range
**[plausibility]** Expect Quantitative Observation _Component_ Value to be in Plausible Range

Denominator resource inclusion:
- `Observation.component.valueQuantity` element is populated 
- `Observation.component.valueQuantity.system` is UCUM and `Observation.component.valueQuantity.code` is populated
- `Observation.component.code` matches a code with a plausibility range in the [OHDSI Data Quality Dashboard definitions](https://github.com/OHDSI/DataQualityDashboard/blob/main/inst/csv/OMOP_CDMv5.4_Concept_Level.csv)

Numerator resource inclusion:
- `Observation.component.valueQuantity` element value is above or below the range defined in the [OHDSI Data Quality Dashboard definitions](https://github.com/OHDSI/DataQualityDashboard/blob/main/inst/csv/OMOP_CDMv5.4_Concept_Level.csv)

### q_cond_gender
**[plausibility]** Expect Condition Gender to be Plausible

Notes:
- The FHIR Patient.gender element represents administrative gender which is not ideal for this purpose. USCDI v2 requires a `us-core-birthsex` extension, though this will be changing in v3 based on feedback from the clinical community. Epic supports inclusion of a `sex-for-clinical-use` extension, though it is unclear how often this is populated in production implementations. Qualifier will use the Epic extension preferentially, falling back to the birth sex extension and then administrative gender.

Denominator resource inclusion:
- `Condition.code` matches a code with a plausible gender in the [OHDSI Data Quality Dashboard definitions](https://github.com/OHDSI/DataQualityDashboard/blob/main/inst/csv/OMOP_CDMv5.4_Concept_Level.csv)
- `Condition.patient` is populated with a reference to a Patient resource in the dataset

Numerator resource inclusion:
- Patient gender does not match the plausible gender for the condition code defined in the [OHDSI Data Quality Dashboard definitions](https://github.com/OHDSI/DataQualityDashboard/blob/main/inst/csv/OMOP_CDMv5.4_Concept_Level.csv)

### q_proc_gender
**[plausibility]** Expect Procedure Gender to be Plausible

Notes:
- See [q_cond_gender](#q_cond_gender) for details on how Patient gender is derived

Denominator resource inclusion:
- `Procedure.code` matches a code with a plausible gender in the [OHDSI Data Quality Dashboard definitions](https://github.com/OHDSI/DataQualityDashboard/blob/main/inst/csv/OMOP_CDMv5.4_Concept_Level.csv)
- `Procedure.patient` is populated with a reference to a Patient resource in the dataset

Numerator resource inclusion:
- Patient gender does not match the plausible gender defined for this procedure code in the [OHDSI Data Quality Dashboard definitions](https://github.com/OHDSI/DataQualityDashboard/blob/main/inst/csv/OMOP_CDMv5.4_Concept_Level.csv)

### q_date_sequence
**[plausibility]** Expect Date to be in Plausible Sequence

Date sequence pairs:

| Resource  Type     | Date Element                       | Subsequent Resource Type | Subsequent Date Element                  |
|--------------------|------------------------------------|--------------------------|------------------------------------------|
| AllergyIntolerance | onsetPeriod.start                  | AllergyIntolerance       | onsetPeriod.end                          |
| AllergyIntolerance | onsetPeriod.start                  | AllergyIntolerance       | recordedDate                             |
| Condition          | onsetPeriod.start OR onsetDateTime | Condition                | abatementDateTime OR abatementPeriod.end |
| Condition          | onsetPeriod.start OR onsetDateTime | Condition                | recordedDate                             |
| Encounter          | period.start                       | Encounter                | period.end                               |
| Immunization       | occurrenceDateTime                 | Immunization             | recorded                                 |
| MedicationRequest  | authoredOn                         | MedicationAdministration | effectiveDateTime                        |
| Patient            | birthDate                          | Patient                  | deceasedDateTime                         |

Denominator resource inclusion:
- Both elements in a date sequence pair are populated

Numerator resource inclusion:
- Subsequent Date listed in the date sequence pair is earlier than the Date Element (both date elements may be the same)

Notes:
- Partial date elements are interpreted as the earliest date possible (e.g., 1999 would be the equivalent of 1999-01-01)
- Partial Subsequent Date elements are interpreted as the latest date possible (e.g., 1999 would be the equivalent of 1999-12-31)

### q_date_in_lifetime
**[plausibility]** Expect Date to be During Patient Life

Examine each of the standard [date elements](#by-date).

Denominator resource inclusion:
- `Patient.birthDate` is populated along with a date from the date elements table
- Reference from the resource to a Patient resource in the dataset

Numerator resource inclusion:
- `Patient.birthDate` is after a date in the data elements table or `Patient.deceasedDateTime` is populated and a date in the date elements table is more than `threshold_days` after the `Patient.deceasedDateTime`

Notes:
- Partial birthDate elements are interpreted as the earliest timestamp possible (e.g., 1999 would be the equivalent of 1999-01-01)
- Partial date elements are interpreted as the latest date possible when compared to birthDate (e.g., 1999 would be the equivalent of 1999-12-31)
- Partial date elements are interpreted as the earliest date possible when compared to deceasedDateTime (e.g., 1999 would be the equivalent of 1999-01-01)

Suggested parameters:
- `threshold_days` - allowed period after death date, defaults to 30 days

### q_date_recent
**[plausibility]** Expect Date to be in Recent Past

Denominator resource inclusion:
- Resource is in the table of standard [date elements](#by-date).

Numerator resource inclusion:
- Any of the populated date elements are before `start_date` parameter and/or after `end_date` parameter
- The [status](#by-status) is not `entered-in-error`
- For Encounters, the [status](#by-status) is not `planned`

Notes:
- Partial date elements are interpreted as the latest date possible when compared to start_date (e.g., 1999 would be the equivalent of 1999-12-31)
- Partial date elements are interpreted as the earliest date possible when compared to end_date (e.g., 1999 would be the equivalent of 1999-01-01)

Suggested parameters:
- `start_date` - a recommended default is `1900-01-01` (arbitrary, but it allows for patients with backdated-to-birth resources, like AllergyIntolerances)
- `end_date` - defaults to metric run time

### q_obs_unit
**[plausibility]** Expect Quantitative Observation Value to Match Common Units

Denominator resource inclusion:
- `Observation.valueQuantity` element is populated 
- `Observation.code` matches a LOINC code with an example unit in the [LOINC database](https://loinc.org/kb/users-guide/loinc-database-structure/#:~:text=example_ucum_units)

Numerator resource inclusion:
- `Observation.valueQuantity.system` is UCUM (`http://unitsofmeasure.org`) and `Observation.valueQuantity.code` is populated
- `Observation.valueQuantity.code` element does not match a unit in the example unit set for any of the LOINC codes in the `Observation.code` element. The unit set is computed by grouping UCUM units by type (e.g., volume measures, size measures) and using these groups to expand the sample unit listed in the LOINC database.

### q_obs_comp_unit
**[plausibility]** Expect Quantitative Observation Component Value to Match Common Units

Denominator resource inclusion:
- `Observation.component.valueQuantity` element is populated 
- `Observation.componet.code` matches a LOINC code with an example unit set in the [LOINC database](https://loinc.org/kb/users-guide/loinc-database-structure/#:~:text=example_ucum_units)
- `Observation.component.valueQuantity.system` is ucum (`http://unitsofmeasure.org`) and `Observation.component.valueQuantity.code` is populated

Numerator resource inclusion:
- `Observation.component.valueQuantity.code` element is not contained in the example unit set for at least one of the LOINC codes in the `Observation.component.code` element

### q_value_unique
**[conformance]** Expect Element Value to be Unique

Denominator resource inclusion:
- Resource is one of the standard [resource types](#by-resource)

Numerator resource inclusion:
- Resource `id` element has the same value for more than one resource of a single Resource Type
- The `meta.versionId` element is not populated for these resources or has the same value in more than one resource

Notes:
- Users may add wish to add other elements to this query which can serve as a base

### q_valid_us_core_v4
**[conformance]** Expect Mandatory US Core Constraints to be Followed

Denominator resource inclusion:

- Resource is one of the standard [US Core profiles](#by-us-core-v4-profile).

Numerator resource inclusion:

- One of the mandatory profile elements is missing or a `SHALL` profile constraint is failing.

Notes:
- This metric must at least validate all profile-specific requirements.
  Ideally, it also validates base FHIR requirements for any fields mentioned by the profile,
  but that can be on a best-effort basis.

### q_system_use
**[conformance]** Expect Common Terminology Systems to be Populated

Coded elements:

| Resource Type      | Element                   | System                                                                                                                                                                                                                         |
|--------------------|---------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| AllergyIntolerance | code                      | http://snomed.info/sct or<br>http://www.nlm.nih.gov/research/umls/rxnorm                                                                                                                                                       |
| Condition          | code                      | http://hl7.org/fhir/sid/icd-9-cm or<br>http://hl7.org/fhir/sid/icd-10-cm or<br>http://snomed.info/sct                                                                                                                          |
| Device             | type                      | http://snomed.info/sct                                                                                                                                                                                                         |
| DiagnosticReport   | code                      | http://loinc.org                                                                                                                                                                                                               |
| DocumentReference  | type                      | http://loinc.org or <br>http://terminology.hl7.org/CodeSystem/v3-NullFlavor                                                                                                                                                    |
| Encounter          | class                     | http://terminology.hl7.org/CodeSystem/v3-ActCode                                                                                                                                                                               |
| Immunization       | vaccineCode               | http://hl7.org/fhir/sid/cvx                                                                                                                                                                                                    |
| Medication         | code                      | http://www.nlm.nih.gov/research/umls/rxnorm                                                                                                                                                                                    |
| MedicationRequest  | medicationCodeableConcept | http://www.nlm.nih.gov/research/umls/rxnorm                                                                                                                                                                                    |
| Observation        | code                      | http://loinc.org                                                                                                                                                                                                               |
| Observation        | valueCodeableConcept      | http://snomed.info/sct                                                                                                                                                                                                         |
| Procedure          | code                      | http://loinc.org or<br>http://snomed.info/sct or<br>http://www.ada.org/cdt or <br>http://www.ama-assn.org/go/cpt or<br>https://www.cms.gov/Medicare/Coding/HCPCSReleaseCodeSets or<br>http://www.cms.gov/Medicare/Coding/ICD10 |

Denominator resource inclusion:
- Resource type is in coded elements list

Numerator resource inclusion:
- Element in coded elements list is present and does not have at least one Coding populated with the system specified in the elements list

Notes:
- The Procedure list (like all the above lists) is based off a US Core profile.
  You may notice some small differences in the provided list and
  [version 4 of US Core](http://hl7.org/fhir/us/core/STU4/ValueSet-us-core-procedure-code.html)
  (namely `www.` in the CDT URL and `https` in the HCPCS URL).
  [Later versions of US Core](http://hl7.org/fhir/us/core/ValueSet-us-core-procedure-code.html)
  correct the apparent typos in version 4, and this metric uses the corrected URLs.

Suggested parameters:
- `skip_elements` - Array of strings in the form of `{resource}.{element}`

### q_ref_target_pop
**[conformance]** Expect Reference Target to be Populated

Reference targets:

| Resource Type      | Element | Target Type |
|--------------------|---------|-------------|
| AllergyIntolerance | patient | Patient     |
| Condition          | subject | Patient     |
| Device             | patient | Patient     |
| DiagnosticReport   | subject | Patient     |
| DocumentReference  | subject | Patient     |
| Encounter          | subject | Patient     |
| Immunization       | patient | Patient     |
| MedicationRequest  | subject | Patient     |
| Observation        | subject | Patient     |
| Procedure          | subject | Patient     |

Denominator resource inclusion:
- Resource type is in reference targets list

Numerator resource inclusion:
- Element in reference target list does not have a reference that points at a relative URL for a resource of the specified type (e.g. `subject.reference` does not start with `Patient/`)

Suggested parameters:
- `skip_elements` - Array of strings in the form of `{resource}.{element}`

### q_ref_target_valid
**[completeness]** Expect Reference Target to be Resolvable when Populated

Reference targets:

| Resource Type      | Element           | Target Type |
|--------------------|-------------------|-------------|
| AllergyIntolerance | patient           | Patient     |
| AllergyIntolerance | encounter         | Encounter   |
| Condition          | subject           | Patient     |
| Condition          | encounter         | Encounter   |
| Device             | patient           | Patient     |
| DiagnosticReport   | subject           | Patient     |
| DiagnosticReport   | encounter         | Encounter   |
| DocumentReference  | subject           | Patient     |
| DocumentReference  | context.encounter | Encounter   |
| Encounter          | subject           | Patient     |
| Immunization       | patient           | Patient     |
| Immunization       | encounter         | Encounter   |
| MedicationRequest  | subject           | Patient     |
| MedicationRequest  | encounter         | Encounter   |
| Observation        | subject           | Patient     |
| Observation        | encounter         | Encounter   |
| Procedure          | subject           | Patient     |
| Procedure          | encounter         | Encounter   |

Denominator resource inclusion:
- Resource type is in reference targets list

Numerator resource inclusion:
- Each element in reference target list has at least one relative URL reference that does not resolve to a resource of the specified type within the dataset being characterized

Suggested parameters:
- `skip_elements` - Array of strings in the form of `{resource}.{element}`

### q_element_present
**[completeness]** Expect Element to be Populated

Notes:
- This overlaps with profile validation - worth keeping?
- Auto generate from US Core required elements (maybe with warnings on unpopulated "must support" elements)?

## Draft Metrics - Data Characterization

### c_resource_count
**[volume]** Count of Unique Resources

Stratified
by [resource type](#by-resource),
by [detailed category](#by-detailed-category),
by [status](#by-status),
by [year](#by-date),
by [month](#by-date).

### c_pt_count
**[demographics]** Count of Patients

Stratified
by birth year,
by deceased status,
by gender,
by [ethnicity](http://hl7.org/fhir/us/core/STU4/StructureDefinition-us-core-ethnicity.html),
by [race](http://hl7.org/fhir/us/core/STU4/StructureDefinition-us-core-race.html),
by [status](#by-status).

Notes:
- `valueCoding` from `us-core-race/ombCategory` extension is used for race and `valueCoding` from the `us-core-ethnicity/ombCategory` extension is used for ethnicity, concatenating the sorted values if there are multiple races listed for an individual patient
- Deceased status is true if `deceasedDateTime` is set or `deceasedBoolean` is true.

### c_pt_deceased_count
**[demographics]** Count of Deceased Patients

Stratified by gender, by age at death, by [status](#by-status).

Notes:
- Patients with a `deceasedBoolean` element populated as `true` are included in the query results with a deceased age of `NULL`
- Attempt to consider birthDate when calculating the age at death
  (i.e. not simply `year_of_death - year_of_birth`).

### c_pt_zipcode_count
**[demographics]** Count of Patients By Zip Code (3 digit)

Notes:
- Only include an address if country is USA or no country is populated and the `address.postalCode` element matches a US zip code pattern (five digits with an optional four digits following a dash)
- Exclude the set of [sparsely populated](https://www.johndcook.com/blog/2016/06/29/sparsely-populated-zip-codes/) 3 digit zip codes to be HIPAA compliant, replacing them with `000`
- Prefer `use=home`, `type=physical` or `both`, and a period without an end date. Fallback order for `address.use` element is `temp`, `work`, `billing`, any

### c_system_use
**[terminology]** Count of Resources by Terminology System

Stratified by
[resource type](#by-resource),
by [basic category](#by-basic-category),
by [status](#by-status),
by [year](#by-date).

Notes:
- This metric will give a sense of what terminology systems are in use
  over time.

| Resource Type      | Coded Element             |
|--------------------|---------------------------|
| AllergyIntolerance | code                      |
| Condition          | code                      |
| Device             | type                      |
| DiagnosticReport   | code                      |
| DocumentReference  | type                      |
| Encounter          | class                     |
| Encounter          | type                      |
| Immunization       | vaccineCode               |
| Medication         | code                      |
| MedicationRequest  | medicationCodeableConcept |
| Observation        | code                      |
| Observation        | valueCodeableConcept      |
| Procedure          | code                      |

### c_system_coverage
**[terminology]** Count of Resources by Terminology System

Stratified by
[resource type](#by-resource),
by [basic category](#by-basic-category),
by [status](#by-status).

Notes:
- For CodeableConcept elements, return the count of resources that can be retrieved with each combination of the terminology systems being used (e.g., count of Procedure resources that have a SNOMED CT, count that have an ICD-10 code, and count with either a SNOMED CT code or ICD-10 code since systems may partially overlap).
- For each element and combination of systems, return the count of resources that also have a text description of the concept.
- This metric will point to the best set of terminology systems to be used when querying the population, and/or highlight terminology mappings that should be adjusted in the source system or through a transformation step in a data pipeline to improve queryability for specific use cases.
- Use the same fields as [c_system_use](#c_system_use)

### c_identifier_coverage
**[terminology]** Count of Resources by Identifier System

Stratified by resource type.

Notes:
- For Identifier elements, return the count of resources that can be retrieved with each combination of the identifier systems being used (e.g., count of patient resources that have a MRN from EHR #1, count that have a MRN from EHR #2, and count with either of those as occurrences may partially overlap).
- This metric will indicate which identifier systems will be available to match patients and encounters with those in other data extracts.


| Resource Type | Identifier Element |
|---------------|--------------------|
| Patient       | identifier         |
| Encounter     | identifier         |

### c_code_use
**[terminology]** Count of Resources by Coded Value

Stratified by [resource type](#by-resource), by [basic category](#by-basic-category), by element, by system, by code.

Notes:
- More complete exploration of elements not included here can be done with the open source [FHIR Data Census Tool](https://github.com/sync-for-science/data-census)

| Resource Type      | Elements                                                                                                |
|--------------------|---------------------------------------------------------------------------------------------------------|
| AllergyIntolerance | _code_, verificationStatus, reaction.manifestation, reaction.severity                                   |
| Condition          | _code_, clinicalStatus, verificationStatus, severity                                                    |
| Device             | _type_, status                                                                                          |
| DocumentReference  | _type_, docStatus, status, contentType                                                                  |
| Encounter          | type, reasonCode, dischargeDisposition                                                                  |
| Immunization       | _vaccineCode_, status                                                                                   |
| MedicationRequest  | _medicationCodeableConcept_, medicationReference.code intent, status, reported                          |
| Observation        | _code_, valueCodeableConcept, status                                                                    |
| Patient            | _identifier_ (system only to avoid leaking PHI), address.use, address.type, telecom.system, telecom.use |
| Procedure          | _code_, category, status                                                                                |

Suggested parameters:
- `skip_elements` - array of '{resource}.{element}' strings with one or more items from the list above

### c_code_use_pt
**[terminology]** Count of Patients per Coded Value

Stratified by resource type, by category, by element, by system, by code.

Notes:
- See coded values in [c_code_use](#c_code_use)

### c_code_use_panel
**[terminology]** Count of Coded Laboratory Panel Components

Stratified by panel system, by panel code, by component system, by component code.

Notes:
- Count of `Observation.code` values that are referenced from a `DiagnosticReport.results` array 

### c_code_first_use
**[terminology]** Count of Earliest Use of Coded Value

Stratified by resource type, by category, by element, by system, by code, by year, by month.

Notes:
- See code elements in [c_code_use](#c_code_use)
- Use standard [date elements](#by-date)

### c_code_last_use
**[terminology]** Count of Latest Use of Coded Value

Stratified by resource type, by category, by element, by system, by code, by year, by month.

Notes:
- See code elements in [c_code_use](#c_code_use)
- Use standard [date elements](#by-date)

### c_resources_per_pt
**[volume]** Distribution of Unique Resources per Patient

Stratified by [resource type](#by-resource), by [detailed category](#by-detailed-category).

Notes:
- Include an "all resources" summary entry.
- Include an "all categories" summary entry for resources that are sliced by category.
- Include a "no recognized categories" entry for resources that are sliced by category,
  which counts any records that do not have a category defined from the
  [detailed category list](#by-detailed-category).
- Useful stats to include:
  - Average resources per patient
  - Max resources among patients
  - Standard deviation of resource count among patients

### c_element_use
**[volume]** Count of Resources with Element Populated

Notes:
- Used to verify population of elements needed for specific types of analysis that are not covered by other metrics. More complete exploration can be done with the open source [FHIR Data Census Tool](https://github.com/sync-for-science/data-census).
- This is kind of a catch-all metric, might be worth removing, but could also be useful to researchers as a base to add their own elements of interest? 

| Resource Type     | Element                                                            |
|-------------------|--------------------------------------------------------------------|
| Observation       | dataAbsentReason, valueQuantity, valueCodeableConcept, valueString |
| Condition         | onsetPeriod.start, onsetDateTime                                   |
| DocumentReference | context.encounter.reference, context.period.start                  |


### c_record_first
**[temporality]** Distribution of Earliest Patient Record

Stratified by [year](#by-date), by [month](#by-date).

Notes:
- Record defined as earliest of `Encounter`, `Observation`, or `MedicationRequest` resource

### c_record_last
**[temporality]** Distribution of Latest Patient Record

Stratified by [year](#by-date), by [month](#by-date).

Notes:
- Record defined as earliest of `Encounter`, `Observation`, or `MedicationRequest` resource

### c_enc_duration
**[temporality]** Distribution of Encounter Duration

Stratified by encounter type.

Notes:
- Length defined as number of days between `Encounter.period.start` and `Encounter.period.end`
- A start and end date must be populated for a resource to be included in this metric

### c_first_enc_age
**[demographics]** Distribution of Patients By Age at First Encounter

Stratified by gender.

Notes:
- Age is based on `Patient.birthDate` element
- First encounter is based on `Encounter.period.start`

### c_us_core_v4_count
**[conformance]** Distribution of US Core supported fields

Stratified
by [US Core profile](#by-us-core-v4-profile),
by every mandatory and must-support field,
by [status](#by-status),
by [year](#by-date).

Notes:
- Flag each field for whether it is present & correctly-defined.
- The absence of a must-support field could either be the data actually missing upstream,
  or a lack of support in the EHR. The best we can do is just flag the missing data and the
  amount of missing fields may surface truths about EHR support.

### c_diagnosis_prevalence
**[condition]** Count of Patients with Documented Disease

Stratified by gender, by condition code.

Notes:
- Include patients who have a condition where `Condition.code` that matches a code with a prevalence range in the [OHDSI Data Quality Dashboard definitions](https://github.com/OHDSI/DataQualityDashboard/blob/main/inst/csv/OMOP_CDMv5.4_Concept_Level.csv)

### c_diagnosis_support
**[condition]** Percentage of Problem List Items with Supporting Observations

Stratified by condition, by [year](#by-date), by [month](#by-date).

Notes:
- This would require clinical input to develop, but the idea is to identify SNOMED codes that could be supported by Observations based on LOINC codes and values. For example, a diabetes / pre-diabetes dx with supporting A1C values, an obesity dx with supporting BMI data, or a hypertension / pre-hypertension dx with supporting bp data. 

### c_date_precision
**[structure]** Distribution of Resource Count by DateTime Element Precision

Stratified by resource type, by category, by date element, by precision level.

Examine all the standard [date elements](#by-date) in addition to these extra elements:

| Resource Type | Date Element                    |
|---------------|---------------------------------|
| Device        | manufactureDate, expirationDate |
| Medication    | batch.expirationDate            |
| Patient       | birthDate, deceasedDateTime     |

Notes:
- `DateTime` element precision levels are `year` (YYYY), `month` (YYYY-MM), `day` (YYYY-MM-DD), `time-seconds` (YYYY-MM-DDThh:mm:ss+zz:zz), and `time-milliseconds` (YYYY-MM-DDThh:mm:ss.fff+zz:zz)
- `Date` element precision levels are the same with the exception of `time-seconds` or `time-milliseconds`

### c_choice_type_populated
**[structure]** Distribution of Resource Count by Choice Type Element Populated

Stratified by resource type, by category, by choice element, by choice type.

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

### c_attachment_count
**[structure]** Count of attachment metadata

Stratified
by [status](#by-status),
by content type,
by language,
by presence of data and/or URL fields,
by format (when applicable).

| Resource Type     | Element       |
|-------------------|---------------|
| DiagnosticReport  | presentedForm |
| DocumentReference | content       |

Notes:
- This metric counts _attachments_ inside resources and their associated metadata.
  Most other metrics count resources, but this one is looking at each attachment.
  Only the status field is taken from the outer resource.
- Normalize content types for better comparison.
  - Strip off extra info like charset information (e.g. `text/plain; charset=utf8`)
    since the primary focus here is on available MIME types.
  - Convert to lowercase, since MIME types are case-insensitive.
- Only DocumentReference has a `format` field associated with the attachment.

### c_content_type_use
**[structure]** Count of resources by attachment content types

Stratified
by [status](#by-status),
by [year](#by-date).
by content types,
by document type,
by document status (when applicable).

| Resource Type     | Attachment Element | Document Type Element |
|-------------------|--------------------|-----------------------|
| DiagnosticReport  | presentedForm      | code                  |
| DocumentReference | content            | type                  |

Notes:
- Normalize content types for better comparison.
  - Strip off extra info like charset information (e.g. `text/plain; charset=utf8`)
    since the primary focus here is on available MIME types.
  - Convert to lowercase, since MIME types are case-insensitive.
- If a resource has multiple content types, present them all.
  - Remove duplicates (a resource might have the same content type in multiple languages).
  - Sort multiple content types in ascending alphabetical order.
- If neither `data` nor `url` fields are present in an attachment,
  that means there is no content available for the given content type & language.
  Thus, you should skip that attachment when surfacing content types.
  (See the `att-1` constraint for
  [Attachments](https://www.hl7.org/fhir/R4/datatypes.html#Attachment).)
- Only DocumentReference has a `docStatus` field.

## Stratification

Many metrics will require stratification by date or category or resource type.
Here is implementation guidance for how to do that.

### By Resource

Implementations must support at least these minimum types,
but can choose to support more.

| Resource Type      |
|--------------------|
| AllergyIntolerance |
| Condition          |
| Device             |
| DiagnosticReport   |
| DocumentReference  |
| Encounter          |
| Immunization       |
| Medication         |
| MedicationRequest  |
| Observation        |
| Patient            |
| Procedure          |

### By Date

Take the stratification date from these fields in order.
This prefers "interaction with health system" dates, then administrative dates like `issued`,
then finally best-effort start dates like `onsetDateTime`.

If a Period is listed, look at both start and end date, in that order.

| Resource Type      | Date Element                                                                 |
|--------------------|------------------------------------------------------------------------------|
| AllergyIntolerance | recordedDate, onsetDateTime, onsetPeriod                                     |
| Condition          | recordedDate, onsetDateTime, onsetPeriod, abatementDateTime, abatementPeriod |
| Device             | NA                                                                           |
| DiagnosticReport   | effectiveDateTime, effectivePeriod, issued                                   |
| DocumentReference  | context.period, date                                                         |
| Encounter          | period                                                                       |
| Immunization       | occurrenceDateTime, recorded                                                 |
| Medication         | NA                                                                           |
| MedicationRequest  | authoredOn                                                                   |
| Observation        | effectiveDateTime, effectivePeriod, effectiveInstant, issued                 |
| Patient            | NA                                                                           |
| Procedure          | performedDateTime, performedPeriod                                           |

### By Status

Stratifying by status is often useful for ignoring `entered-in-error` resources or
otherwise finding patterns in resource lifecycles.

| Resource Type      | Status Element     | Status System                                                         |
|--------------------|--------------------|-----------------------------------------------------------------------|
| AllergyIntolerance | verificationStatus | http://terminology.hl7.org/CodeSystem/allergyintolerance-verification |
| Condition          | verificationStatus | http://terminology.hl7.org/CodeSystem/condition-ver-status            |
| Device             | status             |                                                                       |
| DiagnosticReport   | status             |                                                                       |
| DocumentReference  | status             |                                                                       |
| Encounter          | status             |                                                                       |
| Immunization       | status             |                                                                       |
| Medication         | status             |                                                                       |
| MedicationRequest  | status             |                                                                       |
| Observation        | status             |                                                                       |
| Patient            | active             |                                                                       |
| Procedure          | status             |                                                                       |

### By Basic Category

Some systems below have codes in parentheses after the system URL.
That means that you need only look for that specific code in the system.
For example, if a `Condition.category` has a SNOMED system but a `12345678` code,
you can treat it as an unrecognized system & code.

| Resource Type      | Category Element | Category System                                                                                                                                                                           |
|--------------------|------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| AllergyIntolerance | NA               | NA                                                                                                                                                                                        |
| Condition          | category         | http://hl7.org/fhir/us/core/CodeSystem/condition-category (`health-concern`) and <br>http://terminology.hl7.org/CodeSystem/condition-category and <br>http://snomed.info/sct (`16100001`) |
| Device             | NA               | NA                                                                                                                                                                                        |
| DiagnosticReport   | NA               | NA                                                                                                                                                                                        |
| DocumentReference  | NA               | NA                                                                                                                                                                                        |
| Encounter          | NA               | NA                                                                                                                                                                                        |
| Immunization       | NA               | NA                                                                                                                                                                                        |
| Medication         | NA               | NA                                                                                                                                                                                        |
| MedicationRequest  | NA               | NA                                                                                                                                                                                        |
| Observation        | category         | http://terminology.hl7.org/CodeSystem/observation-category                                                                                                                                |
| Patient            | NA               | NA                                                                                                                                                                                        |
| Procedure          | NA               | NA                                                                                                                                                                                        |

### By Detailed Category

Some systems below have codes in parentheses after the system URL.
That means that you need only look for that specific code in the system.
For example, if a `Condition.category` has a SNOMED system but a `12345678` code,
you can treat it as an unrecognized system & code.

| Resource Type      | Category Element | Category System                                                                                                                                                                           |
|--------------------|------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| AllergyIntolerance | category         | `biologic`, `environment`, `food`, `medication`                                                                                                                                           |
| Condition          | category         | http://hl7.org/fhir/us/core/CodeSystem/condition-category (`health-concern`) and <br>http://terminology.hl7.org/CodeSystem/condition-category and <br>http://snomed.info/sct (`16100001`) |
| Device             | NA               | NA                                                                                                                                                                                        |
| DiagnosticReport   | category         | http://loinc.org (`LP29684-5`, `LP29708-2`, `LP7839-6`) and<br>http://terminology.hl7.org/CodeSystem/v2-0074 (`LAB`)                                                                      |
| DocumentReference  | category         | http://hl7.org/fhir/us/core/CodeSystem/us-core-documentreference-category                                                                                                                 |
| Encounter          | class            | http://terminology.hl7.org/CodeSystem/v3-ActCode                                                                                                                                          |
| Immunization       | NA               | NA                                                                                                                                                                                        |
| Medication         | NA               | NA                                                                                                                                                                                        |
| MedicationRequest  | category         | http://terminology.hl7.org/CodeSystem/medicationrequest-category                                                                                                                          |
| Observation        | category         | http://terminology.hl7.org/CodeSystem/observation-category                                                                                                                                |
| Patient            | NA               | NA                                                                                                                                                                                        |
| Procedure          | NA               | NA                                                                                                                                                                                        |

### By US Core v4 Profile

Some resources have multiple
[profiles](http://hl7.org/fhir/us/core/STU4/profiles-and-extensions.html)
that apply to them.
Here is guidance on how to determine which profile to apply to a given resource in those cases.

When detecting a profile, look **only** for the provided detection rule.
For example, Body Height resources _should_ have both a `8302-2` LOINC code and
a `vital-signs` category.
But when checking validation, a resource might have the right code but be missing the category.
It should still be detected as a Body Height resource (a non-compliant one!) in that case.

| Resource Type      | Profile                                                   | Detection Rule                |
|--------------------|-----------------------------------------------------------|-------------------------------|
| AllergyIntolerance | AllergyIntolerance                                        | NA                            |
| Condition          | Condition                                                 | NA                            |
| Device             | Implantable Device                                        | NA*                           |
| DiagnosticReport   | DiagnosticReport Lab                                      | Has a `LAB` category          |
| DiagnosticReport   | DiagnosticReport Note                                     | Has **no** `LAB` category     |
| DocumentReference  | DocumentReference                                         | NA                            |
| Encounter          | Encounter                                                 | NA                            |
| Immunization       | Immunization                                              | NA                            |
| Medication         | Medication                                                | NA                            |
| MedicationRequest  | MedicationRequest                                         | NA                            |
| Observation        | Blood Pressure                                            | Has a `85354-9` LOINC code    |
| Observation        | BMI                                                       | Has a `39156-5` LOINC code    |
| Observation        | Body Height                                               | Has a `8302-2` LOINC code     |
| Observation        | Body Temperature                                          | Has a `8310-5` LOINC code     |
| Observation        | Body Weight                                               | Has a `29463-7` LOINC code    |
| Observation        | Head Circumference                                        | Has a `9843-4` LOINC code     |
| Observation        | Heart Rate                                                | Has a `8867-4` LOINC code     |
| Observation        | Observation Lab                                           | Has a `laboratory` category   |
| Observation        | Pediatric BMI for Age                                     | Has a `59576-9` LOINC code    |
| Observation        | Pediatric Head Occipital-frontal Circumference Percentile | Has a `8289-1` LOINC code     |
| Observation        | Pediatric Weight for Height Observation                   | Has a `77606-2` LOINC code    |
| Observation        | Pulse Oximetry                                            | Has a `59408-5` LOINC code    |
| Observation        | Respiratory Rate                                          | Has a `9279-1` LOINC code     |
| Observation        | Smoking Status                                            | Has a `72166-2` LOINC code    |
| Observation        | Vital Signs                                               | Has a `vital-signs` category  |
| Patient            | Patient                                                   | NA                            |
| Procedure          | Procedure                                                 | NA                            |

\* Since it is difficult to restrict to only the implantable devices,
this may be "noisy" and include non-implantable devices too.
