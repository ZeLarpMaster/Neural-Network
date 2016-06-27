note
	description: "{MENU} used to let the user decide between playing against an AI of another player."
	author: "Louis Marchand"
	date: "Tue, 15 Dec 2015 00:42:19 +0000"
	revision: "1.0"

class
	MENU_MULTIPLAYER

inherit
	MENU
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make(a_window:GAME_WINDOW_RENDERED; a_ressources_factory:RESSOURCES_FACTORY)
			-- <Precursor>
		do
			Precursor(a_window, a_ressources_factory)
			add_item ("1 player")
			add_item ("2 players")
		end

feature -- Access

	is_single_player:BOOLEAN
			-- The user has selected to play against an artifical intelligence
		do
			Result := selected_item = 1
		end

	is_two_player:BOOLEAN
			-- The user has decide to play two player with the same mouse
		do
			Result := selected_item = 2
		end

end
