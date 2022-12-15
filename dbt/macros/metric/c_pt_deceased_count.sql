{% macro c_pt_deceased_count(flat_patient) %}
	SELECT
		date_part('year', birth_date::DATE) AS birth_year,
		is_deceased,
		date_part('year', death_date::DATE) AS death_year,
		sex,
		COUNT(DISTINCT id) AS cnt
	FROM 
		{{flat_patient}}
	WHERE
		is_deceased 
	GROUP BY 1,2,3,4
{% endmacro %}