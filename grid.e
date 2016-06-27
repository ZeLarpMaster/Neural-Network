note
	description: "Abstraction of a game grid"
	author: "Louis Marchand"
	date: "Tue, 08 Dec 2015 22:50:32 +0000"
	revision: ""

deferred class
	GRID

inherit
	PANEL
		rename
			make as make_panel
		end

feature {NONE} -- Initialization

	make(a_ressources_factory:RESSOURCES_FACTORY; a_x, a_y, a_width, a_height:INTEGER)
			-- Initialization of `Current' with `a_x', `a_y', `a_width' and `a_height' as `bound' values
			-- and using `a_ressources_factory' to get image ressources
		do
			make_panel(a_x, a_y, a_width, a_height)
			ressources_factory := a_ressources_factory
			image := a_ressources_factory.grid_image
		end

feature -- Access

	items:LIST[LIST[detachable GRID_ITEM]]
			-- The {MARKS} that the players have put in `Current'
		deferred
		end

	has_o_won:BOOLEAN
			-- The player O has won the game
		deferred
		end

	has_x_won:BOOLEAN
			-- The player X has won the game
		deferred
		end

	is_full:BOOLEAN
			-- Every cell of `Current' has been used
		deferred
		end

	image:GAME_TEXTURE
			-- The image representing `Current'

	draw(a_renderer:GAME_RENDERER)
			-- Draw the representation of `Current' on the `a_renderer'
		do
			a_renderer.draw_sub_texture_with_scale (
									image, 0, 0, image.width, image.height,
									bound.x, bound.y, bound.width, bound.height
								)
		end

	select_cell_at(a_o_turn:BOOLEAN; a_x, a_y:INTEGER)
			-- Select the cell at position (`a_x',`a_y').
			-- If `a_o_turn' is set, it is the O player
			-- that have launch the select, X if not.
		deferred
		end

	select_cell(a_o_turn:BOOLEAN; a_line, a_column:INTEGER)
			-- Select the cell `a_line',`a_column'.
			-- If `a_o_turn' is set, it is the O player
			-- that have launch the select, X if not.
		deferred
		end


	last_selected_cell:detachable TUPLE[line, column:INTEGER]
			-- Indicate the indexes of the cell selected by the last call to `select_cell_at'
			-- and `select_cell'. Void if no cell selected

	clear_last_selected_cell
			-- Remove the `last_selected_cell'
		do
			last_selected_cell := Void
		end

feature {NONE} -- Implementation

	ressources_factory:RESSOURCES_FACTORY
			-- The factory that generate image ressources

end
