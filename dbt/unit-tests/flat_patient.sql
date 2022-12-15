SELECT * FROM (
	{{ print("test_flatten_patient_use_best_gender") }}
	{{ count_rows( test_flatten_patient_use_best_gender() ) }}
	UNION ALL
	{{ print("test_flatten_patient_deceased_choices") }}
	{{ count_rows( test_flatten_patient_deceased_choices() ) }}
	UNION ALL
	{{ print("test_flatten_patient_race") }}
	{{ count_rows( test_flatten_patient_race() ) }}
	UNION ALL
	{{ print("test_flatten_patient_ethnicity") }}
	{{ count_rows( test_flatten_patient_ethnicity() ) }}
	UNION ALL
	{{ print("test_flatten_patient_epic") }}
	{{ count_rows( test_flatten_patient_epic() ) }}
	UNION ALL
	{{ print("test_flatten_patient_simple") }}
	{{ count_rows( test_flatten_patient_simple() ) }}
) a
WHERE rows > 0