SELECT * FROM (
	{{ print("test_patient_deceased_count_simple") }}
	{{ count_rows( test_patient_deceased_count_simple() ) }}
	UNION ALL
	{{ print("test_patient_deceased_count_no_death_date") }}
	{{ count_rows( test_patient_deceased_count_no_death_date() ) }}
) a
WHERE rows > 0