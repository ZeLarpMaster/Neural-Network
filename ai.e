note
	description: "Summary description for {AI}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AI


feature {NONE} -- Initialization

	make(a_is_o:BOOLEAN)
		do
			is_o := a_is_o
		end

feature -- Access

	play(a_grid:GRID)
			-- Select the first selectionnable cell in `a_grid'
		require
			Is_Playable: not a_grid.is_full and not a_grid.has_o_won and not a_grid.has_x_won
		deferred
		end

	is_o:BOOLEAN
			-- If set, `Current' as the {MARKS} 0; X if unset.
end
