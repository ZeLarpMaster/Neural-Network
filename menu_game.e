note
	description: "{MENU} to let the ser decide what kind of Tic Tac Toe game variant it want to play"
	author: "Louis Marchand"
	date: "Tue, 15 Dec 2015 00:42:19 +0000"
	revision: "1.0"

class
	MENU_GAME

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
			set_title ("Select game type")
			add_item ("Standard Tic Tac Toe")
			add_item ("Ultimate Tic Tac Toe")
		end

feature -- Access

	is_standard_selected:BOOLEAN
			-- The user has selected a Standard Tic Tac Toe game
		do
			Result := selected_item = 1
		end

	is_ultimate_selected:BOOLEAN
			-- The user has selected an Ultimate Tic Tac Toe game
		do
			Result := selected_item = 2
		end

end
