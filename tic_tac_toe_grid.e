note
	description: "The game grid"
	author: "Louis Marchand"
	date: "Mon, 07 Dec 2015 15:46:55 +0000"
	revision: "1.0"

class
	TIC_TAC_TOE_GRID

inherit
	GRID
		redefine
			make, draw
		end
	GRID_ITEM

create
	make

feature -- Initialization

	make(a_ressources_factory:RESSOURCES_FACTORY; a_x, a_y, a_width, a_height:INTEGER)
			-- <Precursor>
		local
			l_marks_list:ARRAYED_LIST[detachable MARKS]
		do
			Precursor {GRID}(a_ressources_factory, a_x, a_y, a_width, a_height)
			create default_o_mark.make (a_ressources_factory, True)
			create default_x_mark.make (a_ressources_factory, False)
			create {ARRAYED_LIST[LIST[detachable MARKS]]} items.make (3)
			across 1 |..| 3 as la_list_index loop
				create l_marks_list.make_filled (3)
				items.extend (l_marks_list)
			end
			last_selected_cell := Void
			has_o_won := False
			has_x_won := False
			winning_index := 0
		end

feature -- Access

	items:LIST[LIST[detachable MARKS]]
			-- The {MARKS} that the players have put in `Current'


	draw(a_renderer:GAME_RENDERER)
			-- Draw the representation of `Current' on the `a_renderer'
		local
			l_marks_width, l_marks_height, i, j:INTEGER
		do
			Precursor {GRID}(a_renderer)
			l_marks_width := bound.width // 3
			l_marks_height := bound.height // 3
			i := 0
			across
				items as la_marks_list
			loop
				j := 0
				across la_marks_list.item as la_marks loop
					if attached la_marks.item as la_mark then
						la_mark.draw (
								a_renderer,
								bound.x + (l_marks_width * j),
								bound.y + (l_marks_height * i),
								l_marks_width, l_marks_height
							)
					end
					j := j + 1
				end
				i := i + 1
			end
			draw_wining_image(a_renderer)
		end

	draw_wining_image(a_renderer:GAME_RENDERER)
			-- Draw the `win_image' on `Current' if needed
		do
			if winning_index /= 0 then
				if win_image = Void then
					create_winning_image (a_renderer)
				end
				if attached win_image as la_win_image then
					if winning_index >= 1 and winning_index <= 3 then
						a_renderer.draw_sub_texture_with_scale (
										la_win_image, 0, 0, la_win_image.width, la_win_image.height,
										bound.x + (bound.width // 6), bound.y + ((winning_index - 1) * (bound.height // 3) + (bound.height // 9)), 4 * (bound.width // 6), (bound.height // 8)
									)
					elseif winning_index >= 4 and winning_index <= 6 then
						a_renderer.draw_sub_texture_with_scale (
										la_win_image, 0, 0, la_win_image.width, la_win_image.height,
										bound.x + ((winning_index - 4) * (bound.width // 3) + (bound.width // 9)), bound.y + (bound.height // 6), (bound.width // 8), 4 * (bound.height // 6)
									)
					elseif winning_index >= 7 then
						a_renderer.draw_sub_texture_with_scale (
										la_win_image, 0, 0, la_win_image.width, la_win_image.height,
										bound.x + (bound.width // 9), bound.y + (bound.height // 9), 7 * (bound.width // 9), 7 * (bound.height // 9)
									)
					end
				end

			end
		end

	win_image:detachable GAME_TEXTURE
			-- Image that is place on the winning marks (row/column/diagonal)

	select_cell_at(a_o_turn:BOOLEAN; a_x, a_y:INTEGER)
			-- Select the cell at position (`a_x',`a_y').
			-- If `a_o_turn' is set, it is the O player
			-- that have launch the select, X if not.
		local
			l_x_index, l_y_index:INTEGER
		do
			last_selected_cell := Void
			if
				a_x >= bound.x and a_x <= bound.x + bound.width and
				a_y >= bound.y and a_y <= bound.y + bound.height
			then
				l_x_index := ((a_x - bound.x) // (bound.width // 3)) + 1
				l_y_index := ((a_y - bound.y) // (bound.height // 3)) + 1
				select_cell(a_o_turn, l_y_index, l_x_index)
			end
		end

	select_cell(a_o_turn:BOOLEAN; a_line, a_column:INTEGER)
			-- Select the cell `a_line',`a_column'.
			-- If `a_o_turn' is set, it is the O player
			-- that have launch the select, X if not.
		local
			l_x_index, l_y_index:INTEGER
		do
			last_selected_cell := Void
			if winning_index = 0 then
				if
					items.valid_index (a_line)
				and then
					items.at (a_line).valid_index (a_column)
				and then
					items.at (a_line).at (a_column) = Void
				then
					last_selected_cell := [a_line, a_column]
					if a_o_turn then
						items.at (a_line).at (a_column) := default_o_mark
					else
						items.at (a_line).at (a_column) := default_x_mark
					end
					valid_winner
				end
			end
		end

	has_o_won:BOOLEAN
			-- The player O has won the game

	has_x_won:BOOLEAN
			-- The player X has won the game

	is_full:BOOLEAN
			-- Every cell of `Current' has been used
		do
			Result := across items as la_marks_list all
								across la_marks_list.item as la_marks all attached la_marks.item end
						end
		end

feature {NONE} -- Implementation

	valid_winner
			-- Valid if there is a winning combinaision. If so, set `has_o_won' or `has_x_won'
		local
			l_winning_marks:detachable MARKS
		do
			across 1 |..| 3 as la_index loop
				if items.at (la_index.item).at (1) = items.at (la_index.item).at (2) and items.at (la_index.item).at (1) = items.at (la_index.item).at (3) then
					if attached items.at (la_index.item).at (1) as la_marks then
						winning_index := la_index.item
						l_winning_marks := la_marks
					end
				end
				if items.at (1).at (la_index.item) = items.at (2).at (la_index.item) and items.at (1).at (la_index.item) = items.at (3).at (la_index.item) then
					if attached items.at (1).at (la_index.item) as la_marks then
						winning_index := la_index.item + 3
						l_winning_marks := la_marks
					end
				end
			end
			if items.at (1).at (1) = items.at (2).at (2) and items.at (1).at (1) = items.at (3).at (3) then
				if attached items.at (1).at (1) as la_marks then
					winning_index := 7
					l_winning_marks := la_marks
				end
			end
			if items.at (2).at (2) = items.at (1).at (3) and items.at (2).at (2) = items.at (3).at (1) then
				if attached items.at (2).at (2) as la_marks then
					l_winning_marks := la_marks
					winning_index := 8
				end
			end
			if attached l_winning_marks as la_marks then
				has_o_won := la_marks.is_o
				has_x_won := la_marks.is_x
			end
		end

	create_winning_image(a_renderer:GAME_RENDERER)
			-- Create the `win_image' depending of the type of winning (see: `winning_index').
		local
			l_old_target: GAME_RENDER_TARGET
			l_old_color:GAME_COLOR
		do
			l_old_target := a_renderer.target
			l_old_color := a_renderer.drawing_color
			if winning_index >= 1 and winning_index <= 3 then
				create_winning_image_target(a_renderer, ressources_factory.winning_image.pixel_format, ressources_factory.winning_image.height, ressources_factory.winning_image.width)
				a_renderer.draw_sub_texture_with_scale_rotation_and_mirror (
									ressources_factory.winning_image, 0, 0, ressources_factory.winning_image.width, ressources_factory.winning_image.height, 0,
									ressources_factory.winning_image.width, ressources_factory.winning_image.width, ressources_factory.winning_image.height, 0, 0,
									-90, False, False
								)
			elseif winning_index >= 4 and winning_index <= 6 then
				win_image := ressources_factory.winning_image
			elseif winning_index = 7 then
				create_winning_image_target(
								a_renderer, ressources_factory.winning_image.pixel_format,
								ressources_factory.winning_image.height + (ressources_factory.winning_image.width // 2),
								ressources_factory.winning_image.height + (ressources_factory.winning_image.width // 2)
							)
				a_renderer.draw_sub_texture_with_scale_rotation_and_mirror (
									ressources_factory.winning_image, 0, 0, ressources_factory.winning_image.width, ressources_factory.winning_image.height, 0,
									ressources_factory.winning_image.width // 2, ressources_factory.winning_image.width,
									{DOUBLE_MATH}.sqrt ((ressources_factory.winning_image.height * ressources_factory.winning_image.height) * 2).floor, 0, 0,
									-45, False, False
								)
			elseif winning_index = 8 then
				create_winning_image_target(
								a_renderer, ressources_factory.winning_image.pixel_format,
								ressources_factory.winning_image.height + (ressources_factory.winning_image.width // 2),
								ressources_factory.winning_image.height + (ressources_factory.winning_image.width // 2)
							)
				a_renderer.draw_sub_texture_with_scale_rotation_and_mirror (
									ressources_factory.winning_image, 0, 0, ressources_factory.winning_image.width, ressources_factory.winning_image.height, ressources_factory.winning_image.width // 2,
									ressources_factory.winning_image.height + ressources_factory.winning_image.width // 2, ressources_factory.winning_image.width,
									{DOUBLE_MATH}.sqrt ((ressources_factory.winning_image.height * ressources_factory.winning_image.height) * 2).floor, 0, 0,
									-135, False, False
								)
			end
			a_renderer.set_drawing_color (l_old_color)
			a_renderer.set_target (l_old_target)
		end

	create_winning_image_target(a_renderer:GAME_RENDERER; a_format:GAME_PIXEL_FORMAT_READABLE; a_width, a_height:INTEGER)
			-- Create the `win_image' texture with dimension (`a_width'x`a_height') as a rendering target for `a_renderer'
			-- using `a_format' as pixel format.
			-- Note: Change the rendering `target' of `a_renderer'
		local
			l_target:GAME_TEXTURE
		do
			create l_target.make_target (a_renderer, a_format, a_width, a_height)
			l_target.enable_alpha_blending
			a_renderer.set_target (l_target)
			a_renderer.set_drawing_color (create {GAME_COLOR}.make (0, 0, 0, 0))
			a_renderer.draw_filled_rectangle (0, 0, l_target.width, l_target.height)
			win_image := l_target
		end

	default_o_mark:MARKS
			-- The O mark used in `Current'

	default_x_mark:MARKS
			-- The X mark used in `Current'

	winning_index:INTEGER
			-- The index of the winning type
			-- 0 means no victory
			-- 1 to 3 means line victory
			-- 4 to 6 means column victory
			-- 7 and 8 means diagonal


invariant
	Winning_Means_index: (has_o_won or has_x_won) implies ((winning_index >= 1) and (winning_index <= 8))
	Index_Means_Winning: (winning_index /= 0) implies (has_o_won or has_x_won)
end
