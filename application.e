note
	description : "A Tic Tac Toe game"
	date        : "Mon, 07 Dec 2015 15:46:55 +0000"
	revision    : "1.0"

class
	APPLICATION

inherit
	GAME_LIBRARY_SHARED
	TEXT_LIBRARY_SHARED

create
	make

feature {NONE} -- Initialization

	make
			-- Run Tic Tac Toe application.
		local
			l_network: NEURAL_NETWORK
		do
			game_library.enable_video
			text_library.enable_text
			run_game
			game_library.clear_all_events
			text_library.quit_library
			game_library.quit_library
		end

	run_game
			-- Create ressources for the game and start the first menu
		local
			l_ressources_factory:RESSOURCES_FACTORY
			l_window_builder:GAME_WINDOW_RENDERED_BUILDER
			l_window:GAME_WINDOW_RENDERED
		do
			create l_window_builder
			l_window_builder.is_resizable := True
			l_window_builder.must_renderer_support_texture_target := True
			l_window := l_window_builder.generate_window
			create l_ressources_factory.make (l_window.renderer, l_window.pixel_format)
			if l_ressources_factory.has_error then
				io.error.put_string ("An error occured when loading ressources.%N")
			else
				run_game_menu(l_window, l_ressources_factory)
			end
		end

	run_game_menu(a_window:GAME_WINDOW_RENDERED; a_ressources_factory:RESSOURCES_FACTORY)
			-- Show the {GAME_MENU} and manage it's output. Show the menu in `a_window' using ressources
			-- from `a_ressources_factory'
		local
			l_menu_game:MENU_GAME
		do
			create l_menu_game.make (a_window, a_ressources_factory)
			if not l_menu_game.has_error then
				l_menu_game.run
				if l_menu_game.is_standard_selected then
					run_multiplayer_menu(False, a_window, a_ressources_factory)
				elseif l_menu_game.is_ultimate_selected then
					run_multiplayer_menu(True, a_window, a_ressources_factory)
				end
			else
				io.error.put_string ("An error occured when loading ressources.%N")
			end
		end

	run_multiplayer_menu(a_is_ultimate:BOOLEAN; a_window:GAME_WINDOW_RENDERED; a_ressources_factory:RESSOURCES_FACTORY)
			-- Show the {MULTIPLAYER_MENU} and manage it's output. Show the menu in `a_window' using ressources
			-- from `a_ressources_factory'. If `a_is_ultimate' is set, the menu must start an Ultimate Tic Tac Toe game;
			-- a standard one if not set.
		local
			l_player_game:MENU_MULTIPLAYER
		do
			create l_player_game.make (a_window, a_ressources_factory)
			if not l_player_game.has_error then
				l_player_game.run
				if l_player_game.is_single_player or l_player_game.is_two_player then
					run_engine(a_is_ultimate, l_player_game.is_single_player, a_window, a_ressources_factory)
				end
			else
				io.error.put_string ("An error occured when loading ressources.%N")
			end
		end

	run_engine(a_is_ultimate, a_with_ai:BOOLEAN; a_window:GAME_WINDOW_RENDERED; a_ressources_factory:RESSOURCES_FACTORY)
			-- Start the appropriate {GAME_ENGINE} depending of `a_is_ultimate'. If `a_with_ai' is set, use an AI in the engine.
			-- Show the game in `a_window' using ressources from `a_ressources_factory'.
		local
			l_game_engine:GAME_ENGINE
		do
			if a_is_ultimate then
				if a_with_ai then
					create {ULTIMATE_ENGINE}l_game_engine.make_with_ai (a_window, a_ressources_factory)
				else
					create {ULTIMATE_ENGINE}l_game_engine.make (a_window, a_ressources_factory)
				end
			else
				if a_with_ai then
					create {TIC_TAC_TOE_ENGINE}l_game_engine.make_with_ai (a_window, a_ressources_factory)
				else
					create {TIC_TAC_TOE_ENGINE}l_game_engine.make (a_window, a_ressources_factory)
				end
			end
			l_game_engine.run
		end


end
