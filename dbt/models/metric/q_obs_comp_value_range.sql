{% call expectations_to_metric('q_obs_comp_value_range', var('metric_include_examples')) %}
	{{ q_obs_value_range( ref("flat_obs_quantitative_component"), ref("obs_plausibility") ) }}
{% endcall %}