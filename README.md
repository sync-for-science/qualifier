# Qualifier

**Qualifier is an open effort to enable researchers and data analysts to easily assess the data quality and content of healthcare data in [HL7 FHIR](http://hl7.org/fhir) format.**

As FHIR interfaces to clinical data proliferate, provider sites, irrespective of size, will be able to take advantage of the FHIR Bulk Data API to access FHIR data without requiring a dedicated data extraction team (for example, see [Epic's Bulk Data Export](https://fhir.epic.com/Documentation?docId=fhir_bulk_data)) or the patient-mediated Patient Access API for FHIR (for example, see [Procure](http://procureproject.org)).

The ability to generate a robust set of FHIR data quality and characterization metrics on data sets, including the ability to identify and guide remediation of data errors (entry, mapping, serialization, export, etc), represents a key enabling technology to speed adoption. When data will be converted from FHIR into other formats, running data quality checks prior to the conversion can identify issues where it may otherwise be difficult to discern or filter out the error, much less trace it back to the source.

The Qualifier metrics take inspiration (and adopt plausible value ranges) from the [OHDSI Data Quality Dashboard](https://data.ohdsi.org/DataQualityDashboard/) as well as other data quality tools. The initial metric set is focused on on evaluating the data quality and characteristics of data sets that comply with the [USCDI v1](https://www.healthit.gov/isa/united-states-core-data-interoperability-uscdi) data subset as described in the [FHIR US Core STU4 Implementation Guide](http://hl7.org/fhir/us/core/STU4/) (IG) and implemented by current EHR systems. However, the metrics can be adapted to work with FHIR data that complies other IGs as well.

Initial work on Qualifier was supported with a grant from the [All of Us Research Project](https://allofus.nih.gov/) and ongoing work is supported with a grant from the [ONC](https://www.hhs.gov/about/news/2023/08/14/hhs-announces-2023-leap-health-it-awardees.html).

## Resources:
- [Metric Definitions](./metrics.md)
- [Cumulus Implementation](https://github.com/smart-on-fhir/cumulus-library-data-metrics/): open source implementation of a growing subset of the Qualifier metrics on the Cumulus FHIR Analytics Platform for AWS Athena and DuckDB.
- [Example DBT Implementation](./app/README.md): open source implementation of a subset of the Qualifier metrics using DBT (Postgres and DuckDB). No longer actively maintained.
