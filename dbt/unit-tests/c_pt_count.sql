SELECT * FROM (
	{{ print("test_patient_count_simple") }}
	{{ count_rows( test_patient_count_simple() ) }}
	UNION ALL
	{{ print("test_patient_count_no_birth_date") }}
	{{ count_rows( test_patient_count_no_birth_date() ) }}
) a
WHERE rows > 0