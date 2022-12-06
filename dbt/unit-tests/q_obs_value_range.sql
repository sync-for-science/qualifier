SELECT * FROM (
	{{ print("test_obs_plaus_valid_value") }}
	{{ count_rows( test_obs_plaus_valid_value() ) }}
	UNION ALL
	{{ print("test_obs_plaus_require_value") }}
	{{ count_rows( test_obs_plaus_require_value() ) }}
	UNION ALL
	{{ print("test_obs_plaus_require_system") }}
	{{ count_rows( test_obs_plaus_require_system() ) }}
	UNION ALL
	{{ print("test_obs_plaus_require_code") }}
	{{ count_rows( test_obs_plaus_require_code() ) }}
	UNION ALL
	{{ print("test_obs_plaus_invalid_high") }}
	{{ count_rows( test_obs_plaus_invalid_high() ) }}
	UNION ALL
	{{ print("test_obs_plaus_invalid_low") }}
	{{ count_rows( test_obs_plaus_invalid_low() ) }}
	UNION ALL
	{{ print("test_obs_plaus_invalid_system") }}
	{{ count_rows( test_obs_plaus_invalid_system() ) }}
	UNION ALL
	{{ print("test_obs_plaus_invalid_code") }}
	{{ count_rows( test_obs_plaus_invalid_code() ) }}
	UNION ALL
	{{ print("test_obs_plaus_invalid_ucum") }}
	{{ count_rows( test_obs_plaus_invalid_ucum() ) }}
) a
WHERE rows > 0