note
	description: "Neuron with no input. This neuron IS the input."
	author: "Guillaume Jean"
	date: "$Date$"
	revision: "$Revision$"

class
	INPUT_NEURON

inherit
	NEURON
		rename
			make as make_neuron,
			make_sigmoidal as make_sigmoidal_neuron
		export
			{NONE} bias
		redefine
			calculate_output
		end

create
	make,
	make_sigmoidal

feature {NONE}
	make
		do
			make_neuron(0)
			current_input := 0
		end

	make_sigmoidal
		do
			make_sigmoidal_neuron(0)
			current_input := 0
		end

feature
	current_input: REAL
		-- Input of the neuron

feature
	calculate_output(a_reference: REAL_64; a_inputs: LINKED_LIST[TUPLE[weight, input: REAL_64]]):REAL_64
		do
			Result := current_input
		end

end
