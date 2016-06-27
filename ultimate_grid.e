note
	description: "A {GRID} that represent an Ultimate Tic Tac Toe board."
	author: "Louis Marchand"
	date: "Tue, 15 Dec 2015 01:16:44 +0000"
	revision: "1.0"

class
	ULTIMATE_GRID

inherit
	GRID
		rename
			is_full as is_draw,
			last_selected_cell as last_selected_sub_grid_cell
		redefine
			make, draw, clear_last_selected_cell
		end

create
	make

feature -- Initialization

	make(a_ressources_factory:RESSOURCES_FACTORY; a_x, a_y, a_width, a_height:INTEGER)
			-- <Precursor>
		local
			l_grid_list:ARRAYED_LIST[TIC_TAC_TOE_GRID]
			l_marging, l_tier_width, l_tier_height:INTEGER

		do
			Precursor {GRID}(a_ressources_factory, a_x, a_y, a_width, a_height)
			l_tier_width := a_width // 3
			l_tier_height := a_height // 3
			l_marging := l_tier_height // 10
			create {ARRAYED_LIST[LIST[TIC_TAC_TOE_GRID]]}items.make (3)
			across 0 |..| 2 as la_i loop
				create l_grid_list.make (3)
				across 0 |..| 2 as la_j loop
					l_grid_list.extend (create {TIC_TAC_TOE_GRID}.make (
														a_ressources_factory,
														a_x + (la_j.item * l_tier_width) + l_marging,
														a_y + (la_i.item * l_tier_height) + l_marging,
														l_tier_width - (l_marging * 2),
														l_tier_height - (l_marging * 2))
													)
				end
				items.extend (l_grid_list)
			end
			grid_to_play := [0, 0]
		end

feature -- Access

	items:LIST[LIST[TIC_TAC_TOE_GRID]]
			-- Every sub {TIC_TAC_TOE_GRID}

	has_o_won:BOOLEAN
			-- <Precursor>
		do
			Result := across items as la_items some
								across la_items.item as la_grid some la_grid.item.has_o_won end
							end
		end

	has_x_won:BOOLEAN
			-- <Precursor>
		do
			Result := across items as la_items some
								across la_items.item as la_grid some la_grid.item.has_x_won end
							end
		end

	is_draw:BOOLEAN
			-- <Precursor
		do
			if
				items.valid_index (grid_to_play.line) and then
				items.at (grid_to_play.line).valid_index (grid_to_play.column)
			then
				Result := items.at (grid_to_play.line).at (grid_to_play.column).is_full
			else
				Result := False
			end
		end


	draw(a_renderer:GAME_RENDERER)
			-- <Precursor>
		local
			l_tier_width, l_tier_height:INTEGER
			l_color_backup:GAME_COLOR
		do
			draw_playing_background(a_renderer)
			Precursor {GRID}(a_renderer)
			across items as la_items loop
				across la_items.item as la_grids loop
					la_grids.item.draw (a_renderer)
				end
			end
		end

	draw_playing_background(a_renderer:GAME_RENDERER)
			-- Draw on `a_renderer' the backround of the sub grid to play into
		local
			l_tier_width, l_tier_height:INTEGER
			l_color_backup:GAME_COLOR
			grid_to_play_backup:TUPLE[line, column:INTEGER]
		do
			if grid_to_play.line > 0 and grid_to_play.column > 0 then
				l_tier_width := bound.width // 3
				l_tier_height := bound.height // 3
				l_color_backup := a_renderer.drawing_color
				a_renderer.set_drawing_color (selected_background_color)
				a_renderer.draw_filled_rectangle (
									bound.x + ((grid_to_play.column - 1) * l_tier_width),
									bound.y + ((grid_to_play.line - 1) * l_tier_height),
									l_tier_width, l_tier_height
								)
				a_renderer.set_drawing_color (l_color_backup)
			else
				grid_to_play_backup := grid_to_play
				across 1 |..| 3 as la_i loop
					across 1 |..| 3 as la_j loop
						grid_to_play := [la_i.item, la_j.item]
						draw_playing_background(a_renderer)
					end
				end
				grid_to_play := grid_to_play_backup
			end
		end

	select_cell_at(a_o_turn:BOOLEAN; a_x, a_y:INTEGER)
			-- <Precursor>
		local
			l_i, l_j:INTEGER
			l_selected:BOOLEAN
			l_selected_cell:detachable TUPLE[line, column:INTEGER]
		do
			clear_last_selected_cell
			if grid_to_play.line < 1 or grid_to_play.column < 1 then
				from
					l_i := 1
					l_selected := False
				until
					l_selected or l_i > items.count
				loop
					from
						l_j := 1
					until
						l_selected or l_j > items.at (l_i).count
					loop
						items.at (l_i).at (l_j).select_cell_at (a_o_turn, a_x, a_y)
						l_selected_cell := items.at (l_i).at (l_j).last_selected_cell
						if attached l_selected_cell as la_cell then
							grid_to_play := [l_i, l_j]
							update_selected_cell
							l_selected := True
						end
						l_j := l_j + 1
					end
					l_i := l_i + 1
				end
			else
				items.at (grid_to_play.line).at (grid_to_play.column).select_cell_at (a_o_turn, a_x, a_y)
				update_selected_cell
			end
		end

	select_cell(a_o_turn:BOOLEAN; a_line, a_column:INTEGER)
			-- <Precursor>
		local
			l_i, l_j:INTEGER
			l_selected:BOOLEAN
			l_selected_cell:detachable TUPLE[line, column:INTEGER]
		do
			clear_last_selected_cell
			if grid_to_play.line = 0 and grid_to_play.column = 0 then
				items.at (((a_line - 1) // 3) + 1).at (((a_column - 1) // 3) + 1).select_cell (a_o_turn, ((a_line - 1) \\ 3) + 1, ((a_column - 1) \\ 3) + 1)
				grid_to_play := [((a_line - 1) // 3) + 1, ((a_column - 1) // 3) + 1]
			else
				if ((a_line - 1) // 3) + 1 = grid_to_play.line and ((a_column - 1) // 3) + 1 = grid_to_play.column then
					items.at (grid_to_play.line).at (grid_to_play.column).select_cell (a_o_turn, ((a_line - 1) \\ 3) + 1, ((a_column - 1) \\ 3) + 1)
				end
			end
			update_selected_cell
		end

	grid_to_play:TUPLE[line, column:INTEGER]
			-- The sub grid in `items' that the player has to play


	last_selected_cell:detachable TUPLE[grid_line, grid_column, cell_line, cell_column:INTEGER]
			-- Indicate the indexes of the cell selected by the last call to `select_cell_at'
			-- and `select_cell' in a sub {GRID} of `items'. Void if no cell selected

	clear_last_selected_cell
			-- Remove the `last_selected_cell'
		do
			last_selected_cell := Void
			last_selected_sub_grid_cell := Void
			across items as la_items loop
				la_items.item.do_all (agent {TIC_TAC_TOE_GRID}.clear_last_selected_cell)
			end
		end

feature {NONE} -- Implementation

	update_selected_cell
			-- Update the `last_selected_sub_grid_cell', `last_selected_cell' and `grid_to_play' after a call to
			-- `select_cell' or `select_cell_at'.
		do
			last_selected_sub_grid_cell := items.at (grid_to_play.line).at (grid_to_play.column).last_selected_cell
			if attached last_selected_sub_grid_cell as la_cell then
				last_selected_cell := [grid_to_play.line, grid_to_play.column, la_cell.line, la_cell.column]
				if not is_draw and not has_o_won and not has_x_won then
					grid_to_play := [la_cell.line, la_cell.column]
				end

			end
		end

	selected_background_color:GAME_COLOR
			-- The {GAME_COLOR} to draw the background of the `grid_to_play'
		once
			create Result.make_rgb (0, 128, 128)
		end

end
