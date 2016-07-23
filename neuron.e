note
	description: "Implemented mathematical representation of a biological neuron."
	author: "Guillaume Jean"
	date: "2016-06-27"
	revision: "16w26"

class
	NEURON

inherit
	MATH_UTILITY

create
	make,
	make_sigmoidal

feature {NONE} -- Initialization

	make(a_initial_bias: REAL_64; a_output: OUTPUT; a_inputs_count: INTEGER)
		do
			is_sigmoidal := False
			bias := a_initial_bias
			output := a_output
			create {ARRAYED_LIST[INPUT]} inputs.make(a_inputs_count)
		end

	make_sigmoidal(a_initial_bias: REAL_64; a_output: OUTPUT; a_inputs_count: INTEGER)
		do
			make(a_initial_bias, a_output, a_inputs_count)
			is_sigmoidal := True
		end

feature -- Access

	is_sigmoidal: BOOLEAN
			-- if this is true, then the neuron is sigmoidal else this is a sign neuron.

	bias: REAL_64 assign set_bias
			-- bias of the neuron

	output: OUTPUT
			-- The value calculated by `Current' using the `inputs' updated by `update_output'

	inputs: LIST[INPUT]
			-- List of inputs used to update the `output'

	weighted_total_input: REAL_64
			-- The sum of `inputs' + `bias'

	update_output
			-- Calculates the new value of `output' with the current value of the `inputs'
		do
			weighted_total_input := 0
			across inputs as la_inputs loop
				weighted_total_input := weighted_total_input + la_inputs.item.value
			end
			weighted_total_input := weighted_total_input + bias
			if is_sigmoidal then
				if not attached {INPUT_CONNECTION} inputs.first then
					output.set_value(weighted_total_input)
				else
					output.set_value(sigmoid(weighted_total_input))
				end
			else
				if weighted_total_input > 0 then
					output.set_value(1)
				else
					output.set_value(0)
				end
			end
		end

	set_bias(a_new_bias: REAL_64)
			-- Modifies `bias'
		do
			bias := a_new_bias
		end
end
