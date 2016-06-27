note
	description: "A player mark"
	author: "Louis Marchand"
	date: "Mon, 07 Dec 2015 15:46:55 +0000"
	revision: "1.0"

class
	MARKS

inherit
	GRID_ITEM

create
	make

feature {NONE} -- Initialization

	make(a_ressources_factory:RESSOURCES_FACTORY; a_is_o:BOOLEAN)
			-- Initialization of `Current' using `a_ressources_factory' to get `image'. If `a_is_o'
			-- is set, `Current' will be a mark of player O. If not, it will be player X.
		do
			is_o := a_is_o
			if a_is_o then
				image := a_ressources_factory.o_image
			else
				image := a_ressources_factory.x_image
			end
		end

feature -- Access

	is_o:BOOLEAN
			-- `Current' is created by player O

	is_x:BOOLEAN
			-- `Current' is created by player X
		do
			Result := not is_o
		end

	draw(a_renderer:GAME_RENDERER; a_x, a_y, a_width, a_height:INTEGER)
			-- Draw `Current' with dimension (`a_width'x`a_height') on the `a_renderer' at position (`a_x', `a_y')
		do
			a_renderer.draw_sub_texture_with_scale (
									image, 0, 0, image.width, image.height,
									a_x, a_y, a_width, a_height
								)
		end

	image:GAME_TEXTURE
			-- The texture representing `Current'

end
