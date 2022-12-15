{% macro c_pt_count(flat_patient) %}
	SELECT
		date_part('year', birth_date::DATE) AS birth_year,
		sex,
		omb_race_code,
		omb_ethnicity_code,
		COUNT(DISTINCT id) AS cnt
	FROM 
		{{flat_patient}}
	GROUP BY 1,2,3,4
{% endmacro %}