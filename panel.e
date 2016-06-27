note
	description: "A part of {GAME_WINDOW}."
	author: "Louis Marchand"
	date: "Tue, 08 Dec 2015 01:19:57 +0000"
	revision: "1.0"

deferred class
	PANEL

feature -- Initialization

	make(a_x, a_y, a_width, a_height:INTEGER)
			-- Initialization of `Current' with `a_x', `a_y', `a_width' and `a_height' as `bound' values
		do
			bound := [a_x, a_y, a_width, a_height]
		end

feature -- Access

	bound:TUPLE[x, y, width, height:INTEGER]
			-- Where to draw `Current'

	draw(a_renderer:GAME_RENDERER)
			-- Draw the representation of `Current' on the `a_renderer'
		deferred
		end

end
