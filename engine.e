note
	description: "An engine that manage a mecahnics on a scene."
	author: "Louis Marchand"
	date: "Tue, 15 Dec 2015 00:42:19 +0000"
	revision: "1.0"

deferred class
	ENGINE

inherit
	GAME_LIBRARY_SHARED

feature {NONE} -- Initialization

	make(a_window:GAME_WINDOW_RENDERED; a_ressources_factory:RESSOURCES_FACTORY)
			-- Initialization of `Current' using `a_window' to show the scene and `a_ressources_factory'
			-- to load ressources.
		require
			No_Ressources_Error: not a_ressources_factory.has_error
		do
			window := a_window
			ressources_factory := a_ressources_factory
		ensure
			window = a_window
			ressources_factory = a_ressources_factory
		end

feature -- Access

	run
			-- Execute `Current'
		do
			game_library.quit_signal_actions.extend (agent on_quit_signal)
			window.expose_actions.extend (agent on_redraw)
			on_redraw(game_library.time_since_create)
			game_library.launch
			game_library.clear_all_events
		end

	stop
			-- Halt the execution of `Current'
		do
			game_library.stop
		end

feature {NONE} -- Implementation

	window:GAME_WINDOW_RENDERED
			-- The game window

	ressources_factory: RESSOURCES_FACTORY
			-- Factory that generate the game images

	on_quit_signal(a_timestamp:NATURAL_32)
			-- When the user close the window
		do
			stop
		end

	on_redraw(a_timestamp:NATURAL_32)
			-- Redraw the scene
		deferred
		end

end
