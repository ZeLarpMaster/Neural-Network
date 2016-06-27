note
	description: "An artifical intelligence that can play Ultimate Tic Tac Toe"
	author: "Louis Marchand"
	date: "Tue, 15 Dec 2015 00:42:19 +0000"
	revision: "1.0"

class
	ULTIMATE_AI

inherit
	AI

create
	make

feature -- Access

	play(a_grid:ULTIMATE_GRID)
			-- <Precursor>
		local
			l_has_selected:BOOLEAN
			i, j:INTEGER
			l_grid:TIC_TAC_TOE_GRID
		do
			from
				i := 1
				l_has_selected := False
			until
				l_has_selected or i > 9
			loop
				from
					j := 1
				until
					l_has_selected or j > 9
				loop
					a_grid.select_cell (is_o, i, j)
					l_has_selected := attached a_grid.last_selected_cell
					j := j + 1
				end
				i := i + 1
			end
		end

end
