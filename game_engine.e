note
	description: "An {ENGINE} that manage a Tic Tac Toe Game variant Engine"
	author: "Louis Marchand"
	date: "Tue, 15 Dec 2015 00:42:19 +0000"
	revision: "1.0"

deferred class
	GAME_ENGINE

inherit
	ENGINE
		redefine
			make, run
		end

feature {NONE} -- Initializaton

	make(a_window:GAME_WINDOW_RENDERED; a_ressources_factory:RESSOURCES_FACTORY)
			-- Initialization of `Current' using `a_window' as `window' and `a_ressources_factory'
			-- as `ressources_factory'
		do
			Precursor(a_window, a_ressources_factory)
			is_o_first_next := True
			window.renderer.set_drawing_color (create {GAME_COLOR}.make_rgb (255, 255, 255))
			reset
			window.renderer.set_logical_size (
							ressources_factory.grid_image.width,
							ressources_factory.grid_image.height + (ressources_factory.grid_image.height // 5)
						)
		end

feature -- Access

	run
			-- <Precursor>
		do
			window.mouse_button_released_actions.extend (agent on_mouse_released)
			Precursor
		end

feature {NONE} -- Implementation

	grid:GRID
			-- The Tic Tac Toe game grid
		deferred
		end

	informations_panel:INFORMATIONS_PANEL
			-- {PANEL} used for drawing informations about the game.

	is_o_turn:BOOLEAN
			-- If set, the player presently playing is O. X if not

	on_redraw(a_timestamp:NATURAL_32)
			-- <Precursor>
		do
			window.renderer.clear
			grid.draw(window.renderer)
			informations_panel.draw (window.renderer)
			window.update
		end

	on_mouse_released(a_timestamp: NATURAL_32; a_mouse_state: GAME_MOUSE_BUTTON_RELEASED_STATE; a_nb_clicks: NATURAL_8)
			-- <Precursor>
		do
			if a_mouse_state.is_left_button_released then
				if grid.has_o_won or grid.has_x_won or grid.is_full then
					reset
					if attached ai as la_ai and then is_o_turn = la_ai.is_o then
						on_redraw(a_timestamp)
						la_ai.play(grid)
						end_turn
					end
				else
					grid.select_cell_at (is_o_turn, a_mouse_state.x, a_mouse_state.y)
					if attached grid.last_selected_cell then
						end_turn
						if not grid.is_full and not grid.has_o_won and not grid.has_x_won then
							if attached ai as la_ai and then is_o_turn = la_ai.is_o then
								on_redraw(a_timestamp)
								la_ai.play(grid)
								end_turn
							end
						end
					end
				end
				on_redraw(a_timestamp)
			end
		end

	end_turn
			-- <Precursor>
		do
			if grid.has_o_won then
				informations_panel.set_winner (True)
			elseif grid.has_x_won then
				informations_panel.set_winner (False)
			elseif grid.is_full then
				informations_panel.set_draw
			else
				is_o_turn := not is_o_turn
				informations_panel.set_player_turn(is_o_turn)
			end
		end

	reset
			-- <Precursor>
		do
			create informations_panel.make (
								ressources_factory, 0,
								ressources_factory.grid_image.height + 1,
								ressources_factory.grid_image.width,
								(ressources_factory.grid_image.height // 5)
							)
			is_o_turn := is_o_first_next
			informations_panel.set_player_turn(is_o_turn)
			is_o_first_next := not is_o_first_next
		end

	is_o_first_next:BOOLEAN
			-- If True, O will start the next game; X if False.

	ai:detachable AI
			-- If attached, the player is against an artifical intelligence
		deferred
		end

end
