note
	description: "{OUTPUT} hooked to {INPUT_CONNECTION}s"
	author: "Guillaume Jean"
	date: "2016-06-27"
	revision: "16w26"

class
	HOOKED_OUTPUT

inherit
	OUTPUT
		redefine
			make,
			set_value
		end

create
	make

feature {NONE} -- Initialization

	make(a_initial_value: REAL_64)
			-- <Precursor>
		do
			create {LINKED_LIST[INPUT_CONNECTION]} connections.make
			Precursor(a_initial_value)
		end

feature -- Access

	connections: LIST[INPUT_CONNECTION]
			-- List of connections between `Current' and the {INPUT_CONNECTION}s in the next {NEURON} layer

	set_value(a_new_value: REAL_64)
			-- <Precursor>
			-- Updates the value of all `connections' to `a_new_value'
		do
			connections.do_all(
						agent (a_connection: INPUT_CONNECTION; a_value: REAL_64)
							do
								a_connection.set_activation(a_value)
							end
						(?,a_new_value)
					)
		end
end
