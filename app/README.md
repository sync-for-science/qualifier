# Qualifier Reference Implementation

**Under active development, not ready for use**

## Dependencies

- [docker desktop v2+](https://www.docker.com/products/docker-desktop/)

or for local installation:

- [python v3.7+](https://www.python.org/downloads/) 
- [dbt v1.3+](https://docs.getdbt.com/docs/get-started/) with [duckdb extension](https://www.python.org/downloads/) and/or [postgres extension](https://docs.getdbt.com/reference/warehouse-setups/postgres-setup)
- [quarto](https://quarto.org/docs/get-started/) and/or [jupyter](https://jupyter.org/install) for generating seed files and viewing output reports. Be sure to install a [PDF engine](https://quarto.org/docs/output-formats/pdf-engine.html) if you'd like to generate reports in PDF format.

## Code structure

- Directories
	- [/dbt/macros/flat-fhir](dbt/macros/flat-fhir/) - dbt macros to project FHIR json into "rectangular" relational models
	- [/dbt/macros/metric](dbt/macros/metric/) - dbt macros to compute quality and characterization metrics
	- [/dbt/macros/unit-tests](dbt/macros/metric/) - unit tests for flat-fhir projections and metric calculation
	- [/dbt/macros/util](dbt/macros/util/) - macros used to avoid repetition
	- [/dbt/models](dbt/models/) - thin wrappers over flat-fhir and metric macros to materialize tables
	- [/dbt/unit-tests](dbt/unit-tests/) - thin wrappers over unit tests to support the dbt test runner
	- [/reports](reports/) - jupyter notebooks to generate metric reports from computed metrics

- Configuration
	- [dbt_project.yml](dbt/dbt_project.yml) - project configuration
	- [profiles.yml](dbt/profiles.yml) - database connection configuration

- SQL Templates
	- [flat_patient](dbt/macros/flat-fhir/flat_patient.sql) ([unit tests](dbt/macros/unit-tests/flat_patient.sql)) -  projection of FHIR Patient resource for metrics 

	- [flat_obs_quantitative.sql](dbt/macros/flat-fhir/flat_obs_quantitative.sql) ([unit tests](dbt/macros/unit-tests/flat_obs_quantitative.sql)) -  projection of FHIR Observation resource with valueQuantity populated for metrics

	- [flat_obs_quantitative_component.sql](dbt/macros/flat-fhir/flat_obs_quantitative_component.sql) ([unit tests](dbt/macros/unit-tests/flat_obs_quantitative_component.sql)) - projection of FHIR Observation resource with component.valueQuantity populated for metrics

	- [q_obs_value_range](dbt/macros/metric/q_obs_value_range.sql) ([unit tests](dbt/macros/unit-tests/q_obs_value_range.sql)) - quality metric calculation using flat_obs_quantitative or flat_obs_quantitative_component

	- [c_resource_count](dbt/macros/metric/c_resource_count.sql) ([unit tests](dbt/macros/unit-tests/c_resource_count.sql)) - characterization metric calculation for counts of resources by category and primary date (where applicable)

	- [c_pt_count](dbt/macros/metric/c_pt_count.sql) ([unit tests](dbt/macros/unit-tests/c_pt_count.sql)) - characterization metric calculation using flat_patient

	- [c_pt_deceased_count](dbt/macros/metric/c_pt_deceased_count.sql) ([unit tests](dbt/macros/unit-tests/c_pt_deceased_count.sql)) - characterization metric calculation using flat_patient

	- [expectations_to_metric](dbt/macros/util/expectations_to_metric.sql) ([unit tests](dbt/macros/unit-tests/expectations_to_metric.sql)) - aggregate quality metrics into standard structure of numerator, denominator and examples

- Misc
	- [build-plausibility-seeds.ipynb](build-plausibility-seeds.ipynb) - jupyter notebook to adapt OHDSI data plausibility definitions for use in the q_obs_value_range metric
	- [table_to_sql](dbt/macros/util/table_to_sql.sql), [import_json](dbt/macros/util/import_json.sql), [compare_tables](dbt/macros/util/compare_tables.sql), [count_rows](dbt/macros/util/count_rows.sql) - custom Jinja macros to support unit testing

- Reports
	- [quality.ipynb](reports/quality.ipynb) - jupyter notebook that produces a quality metric report 
	- [characterization.ipynb](reports/characterization.ipynb) - jupyter notebook that produces a characterization metric report 