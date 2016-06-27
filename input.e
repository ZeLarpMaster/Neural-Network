note
	description: "The input of a {NEURON}"
	author: "Guillaume Jean"
	date: "2016-06-27"
	revision: "16w26"

class
	INPUT

inherit
	VALUE[REAL_64]
		rename
			item as value,
			set_item as set_value
		end

create
	make

end
