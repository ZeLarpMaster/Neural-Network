note
	description: "A game engine to manage a Tic_Tac_Toe game"
	author: "Louis Marchand"
	date: "Sun, 06 Dec 2015 22:12:04 +0000"
	revision: "1.0"

class
	TIC_TAC_TOE_ENGINE

inherit
	GAME_ENGINE
		redefine
			reset
		end

create
	make,
	make_with_ai

feature {NONE} -- Initializaton

	make_with_ai(a_window:GAME_WINDOW_RENDERED; a_ressources_factory:RESSOURCES_FACTORY)
			-- Initialization of `Current' using `a_window' as `window' and `a_ressources_factory'
			-- as `ressources_factory'. The player is against an `ai'
		do
			make(a_window, a_ressources_factory)
			create ai.make (False)
		end

feature {NONE} -- Implementation

	grid:TIC_TAC_TOE_GRID
			-- <Precursor>

	reset
			-- <Precursor>
		do
			create grid.make (ressources_factory, 0, 0, ressources_factory.grid_image.width, ressources_factory.grid_image.height)
			Precursor
		end

	ai:detachable TIC_TAC_TOE_AI
			-- <Precursor>

end
