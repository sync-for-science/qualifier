SELECT * FROM {{ ref("q_obs_value_range") }}
UNION ALL
SELECT * FROM {{ ref("q_obs_comp_value_range" )}}