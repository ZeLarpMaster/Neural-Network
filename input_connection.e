note
	description: "The connection between two {NEURON}s"
	author: "Guillaume Jean"
	date: "2016-06-27"
	revision: "16w26"

class
	INPUT_CONNECTION

inherit
	INPUT
		rename
			value as weighted_input
		export
			{NONE} set_value
		redefine
			weighted_input,
			make
		end

create
	make

feature {NONE} -- Initialization

	make(a_initial_activation: REAL_64)
			-- Initializes `Current' with `activation' set to `a_initial_activation'
		do
			activation := a_initial_activation
			weight := 1
		end

feature -- Access

	weighted_input: REAL_64
			-- <Precursor>
		do
			Result := weight * activation
		end

	activation: REAL_64 assign set_activation
			-- Non-weighted input value of `Current'

	weight: REAL_64 assign set_weight
			-- Weight of `Current'

	set_activation(a_new_activation: REAL_64)
			-- Sets `activation' to `a_new_weight'
		do
			activation := a_new_activation
		end

	set_weight(a_new_weight: REAL_64)
			-- Sets `weight' to `a_new_weight'
		do
			weight := a_new_weight
		end

end
