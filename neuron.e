note
	description: "Implemented mathematical representation of a biological neuron."
	author: "Guillaume Jean"
	date: "$Date$"
	revision: "$Revision$"

class
	NEURON

inherit
	MATH_CONST

create
	make,
	make_sigmoidal

feature {NONE}
	make(a_initial_bias: REAL_64)
		do
			is_sigmoidal := False
			current_output := 0
			bias := a_initial_bias
		end

	make_sigmoidal(a_initial_bias: REAL_64)
		do
			make(a_initial_bias)
			is_sigmoidal := True
		end

feature {NONE}
	is_sigmoidal: BOOLEAN
		-- if this is true, then the neuron is sigmoidal else this is a sign neuron.
	current_output: REAL_64
		-- this is 0 or 1 when this is a sign neuron.
	bias: REAL_64
		-- bias of the neuron

feature
	calculate_output(a_reference: REAL_64; a_inputs: LINKED_LIST[TUPLE[weight, input: REAL_64]]):REAL_64
		local
			l_weighted_inputs_sum: REAL_64
		do
			l_weighted_inputs_sum := 0
			from
				a_inputs.start
			until
				a_inputs.after
			loop
				l_weighted_inputs_sum := l_weighted_inputs_sum + (a_inputs.item.weight * a_inputs.item.input)
				a_inputs.forth
			end
			l_weighted_inputs_sum := l_weighted_inputs_sum - a_reference
			if is_sigmoidal then
				current_output := 1 / (1 + (Euler ^ -l_weighted_inputs_sum))
			else
				if l_weighted_inputs_sum >= 0 then
					current_output := 1
				else
					current_output := 0
				end
			end
			Result := current_output
		end

	set_bias(a_new_bias: REAL_64)
		do
			bias := a_new_bias
		end
end
