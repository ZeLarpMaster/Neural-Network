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
		do
			game_library.enable_video
			text_library.enable_text
			run_game
			game_library.clear_all_events
			text_library.quit_library
			game_library.quit_library
		end

	run_game
			-- AI Training
		local
			l_window_builder: GAME_WINDOW_SURFACED_BUILDER
			l_window: GAME_WINDOW_SURFACED
		do
			create l_window_builder
			l_window_builder.is_resizable := True
			l_window := l_window_builder.generate_window
			run_training_screen(l_window)
		end

	run_training_screen(a_window:GAME_WINDOW_SURFACED)
			-- Shows the training images and labels while the network learns
		local
			l_font: TEXT_FONT
			l_foreground, l_background: GAME_COLOR
			l_pixel_format: GAME_PIXEL_FORMAT
			l_current_image: GAME_SURFACE
			l_current_label: TEXT_SURFACE_SHADED
			l_image_file, l_label_file: RAW_FILE
			i, j, k: INTEGER
			l_infos: TUPLE[images, width, height: INTEGER]
			l_neural_network: NEURAL_NETWORK
			l_pixel_values: LIST[REAL_64]
			l_expected_output: LIST[REAL_64]
			l_expected_number: INTEGER
		do
			l_infos := get_info
			create l_neural_network.make(create {ARRAYED_LIST[INTEGER]}.make_from_array(<<l_infos.width * l_infos.height, 200, 10>>))
			create {ARRAYED_LIST[REAL_64]} l_pixel_values.make_filled(l_infos.width * l_infos.height)
			create {ARRAYED_LIST[REAL_64]} l_expected_output.make_filled(10)
			create l_image_file.make_open_read("C:/Users/ZeLarpMaster/Desktop/t10k-images.idx3-ubyte")
			l_image_file.go(20)
			create l_label_file.make_open_read("C:/Users/ZeLarpMaster/Desktop/t10k-labels.idx1-ubyte")
			l_label_file.go(8)
			create l_font.make("C:/Windows/Fonts/Ubuntu-R.ttf", 30)
			l_font.open
			create l_background.make_rgb(0, 0, 0)
			create l_foreground.make_rgb(255, 255, 255)
			create l_pixel_format
			l_pixel_format.set_rgba8888
			create l_current_image.make_for_pixel_format(l_pixel_format, l_infos.width, l_infos.height)
			from
				k := 1
			until
				k > l_infos.images
			loop
				l_current_image.lock
				l_pixel_values.start
				from
					i := 1
				until
					i > l_infos.width
				loop
					from
						j := 1
					until
						j > l_infos.height
					loop
						l_image_file.read_natural_8
						l_pixel_values.put(l_image_file.last_natural_8 / 255)
						l_current_image.pixels.set_pixel(create {GAME_COLOR}.make_rgb(l_image_file.last_natural_8, l_image_file.last_natural_8, l_image_file.last_natural_8), i, j)
						l_pixel_values.forth
						j := j + 1
					end
					i := i + 1
				end
				l_current_image.unlock
				a_window.surface.draw_surface(l_current_image, 0, 0)
				l_label_file.read_natural_8
				l_expected_number := l_label_file.last_natural_8.as_integer_32
				create l_current_label.make(l_expected_number.out, l_font, l_foreground, l_background)
				a_window.surface.draw_surface(l_current_label, 50, 10)
				a_window.update
				l_expected_output.at(l_expected_number + 1) := 1.0
				l_neural_network.learn_back_propagate(l_pixel_values, l_expected_output)
				l_expected_output.at(l_expected_number + 1) := 0.0
				k := k + 1
			end
		end

	get_info: TUPLE[images, width, height: INTEGER]
		local
			l_image_file: GAME_FILE
		do
			create Result
			create l_image_file.make("C:/Users/ZeLarpMaster/Desktop/t10k-images.idx3-ubyte")
			l_image_file.open_read
			l_image_file.go(4)
			l_image_file.read_natural_32_big_endian
			Result.images := l_image_file.last_natural_32.as_integer_32
			l_image_file.read_natural_32_big_endian
			Result.width := l_image_file.last_natural_32.as_integer_32
			l_image_file.read_natural_32_big_endian
			Result.height := l_image_file.last_natural_32.as_integer_32
		end

	run_game_2
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
