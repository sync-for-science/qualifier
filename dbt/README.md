# Qualifier Reference Implementation

**Under active development, not ready for use**

Dependencies:
- [python v3+](https://www.python.org/downloads/) 
- [dbt v1.3+](https://docs.getdbt.com/docs/get-started/) with [duckdb extension](https://www.python.org/downloads/)  and/or [postgres extension](https://docs.getdbt.com/reference/warehouse-setups/postgres-setup)
- [jupyter](https://jupyter.org/install) for generating seed files and viewing output 


Important Files:

- Configuration
	- [dbt_project.yml](dbt_project.yml) - project configuration
	- [profiles.yml](profiles.yml) - database connection configuration

- SQL Templates
	- [flat_patient](macros/flat-fhir/flat_patient.sql) ([unit tests](macros/unit-tests/flat_patient.sql)) -  projection of FHIR Patient resource for metrics 
	- [flat_obs_quantitative.sql](macros/flat-fhir/flat_obs_quantitative.sql) ([unit tests](macros/unit-tests/flat_obs_quantitative.sql)) -  projection of FHIR Observation resource with valueQuantity populated for metrics
	- [flat_obs_quantitative_component.sql](macros/flat-fhir/flat_obs_quantitative_component.sql) ([unit tests](macros/unit-tests/flat_obs_quantitative_component.sql)) - projection of FHIR Observation resource with component.valueQuantity populated for metrics
	- [q_obs_value_range](macros/metric/q_obs_value_range.sql) ([unit tests](macros/unit-tests/q_obs_value_range.sql)) - quality metric calculation using flat_obs_quantitative or flat_obs_quantitative_component
	- [c_pt_count](macros/metric/c_pt_count.sql) ([unit tests](macros/unit-tests/c_pt_count.sql)) - characterization metric calculation using flat_patient
	- [c_pt_deceased_count](macros/metric/c_pt_deceased_count.sql) ([unit tests](macros/unit-tests/c_pt_deceased_count.sql)) - characterization metric calculation using flat_patient
	- [expectations_to_metric](macros/util/expectations_to_metric.sql) ([unit tests](macros/unit-tests/expectations_to_metric.sql)) - aggregate quality metrics into standard structure of numerator, denominator and examples

- Misc
	- [build-plausibility-seeds.ipynb](build-plausibility-seeds.ipynb) - jupyter notebook to adapt OHDSI data plausibility definitions for use in the q_obs_value_range metric
	- [table_to_sql](macros/util/table_to_sql.sql), [import_json](macros/util/import_json.sql), [compare_tables](macros/util/compare_tables.sql), [count_rows](macros/util/count_rows.sql) - custom Jinja macros to support unit testing
