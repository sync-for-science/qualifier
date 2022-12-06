# Qualifier

**Qualifier is an open effort to enable researchers and data analysts to easily assess the data quality and content of healthcare data in [HL7 FHIR](http://hl7.org/fhir) format.**

As FHIR interfaces to clinical data proliferate, provider sites, irrespective of size, will be able to take advantage of the FHIR Bulk Data API to access FHIR data without requiring a dedicated data extraction team (for example, see [Epic's Bulk Data Export](https://fhir.epic.com/Documentation?docId=fhir_bulk_data)) or the patient-mediated Patient Access API for FHIR (for example, see [Procure](http://procureproject.org)).

Questions like the following will likely need clear answers: Are the data elements needed for a study included in the data set? Is the data set complete or were some types of labs omitted? Are the included labs associated with the correct terminology codes? Are the diagnosed conditions in the data even plausible given the recorded patient characteristics?

The ability to generate a robust set of FHIR data quality and characterization metrics on data sets, including the ability to identify and guide remediation of data errors (entry, mapping, serialization, export, etc), represents a key enabling technology to speed adoption. When data will be converted from FHIR into other formats, running data quality checks prior to the conversion can identify issues where it may otherwise be difficult to discern or filter out the error, much less trace it back to the source.

Qualifier is a companion effort to the open source [FHIR Data Census Data Exploration Tool](https://github.com/sync-for-science/data-census). The metrics take inspiration (and adopt plausible value ranges) from the [OHDSI Data Quality Dashboard](https://data.ohdsi.org/DataQualityDashboard/) as well as other data quality tools. 

The work is funded by a grant from the [All of Us Research Project](https://allofus.nih.gov/).

## Resources:
- [Metric Definitions](./metrics.md)
- [Reference Implementation](./dbt/README.md)