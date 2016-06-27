note
	description: "Container for a type"
	author: "Guillaume Jean"
	date: "2016-06-27"
	revision: "16w26"

class
	VALUE[G]

create
	make

feature {NONE} -- Initialization

	make(a_initial_value: like item)
			-- Initializes `Current' with `item' set to `a_initial_value'
		do
			set_item(a_initial_value)
		end

feature -- Access

	item: G assign set_item
			-- Value of `Current'
		do
			Result := internal_value
		end

	set_item(a_new_value: like item)
			-- Modifies `item'
		do
			internal_value := a_new_value
		end

feature {NONE} -- Implementation

	internal_value: like item
			-- Internal representation of `item'

end
