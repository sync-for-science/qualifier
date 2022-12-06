{% macro q_obs_value_range(flat_observation, seed_data) %}
	SELECT
		p.*, 
		qo.quantity_value, 
		qo.id, 
		CASE 
			WHEN quantity_value < p.low OR quantity_value > p.high
			THEN qo.id
			ELSE NULL
		END AS score
	FROM 
		{{seed_data}} p
	INNER JOIN 
		{{flat_observation}} qo
	ON 
		p.code = qo.code 
		AND p.system = qo.system 
		AND qo.quantity_code = p.ucum_code
	WHERE qo.quantity_value IS NOT NULL
		AND qo.code IS NOT NULL
		AND qo.system IS NOT NULL
{% endmacro %}