note
	description: "{PANEL} that show information about the game."
	author: "Louis Marchand"
	date: "Tue, 08 Dec 2015 01:19:57 +0000"
	revision: "1.0"

class
	INFORMATIONS_PANEL

inherit
	PANEL
		rename
			make as make_panel
		end

create
	make

feature {NONE} -- Initialization

	make(a_ressources_factory:RESSOURCES_FACTORY; a_x, a_y, a_width, a_height:INTEGER)
			-- Initialization of `Current' with `a_x', `a_y', `a_width' and `a_height' as `bound' values
			-- and using `a_ressources_factory' to get ressources
		do
			make_panel (a_x, a_y, a_width, a_height)
			ressources_factory := a_ressources_factory
			font := a_ressources_factory.informations_font (a_height // 2)
		end

feature -- Access

	draw(a_renderer:GAME_RENDERER)
			-- <Precursor>
		local
			l_mark_width, l_informations_width:INTEGER
		do
			if attached text_surface as la_surface and not attached text_texture then
				create text_texture.make_from_surface (a_renderer, la_surface)
			end
			if attached text_texture as la_text then
				if attached image_player_texture as la_mark then
					l_mark_width := ((bound.height // 2) * la_mark.width) // la_mark.height
					l_informations_width := la_text.width + l_mark_width
					a_renderer.draw_sub_texture_with_scale (
													la_mark, 0, 0, la_mark.width, la_mark.height,
													bound.x + ((bound.width - l_informations_width) // 2) + la_text.width,
													bound.y + (bound.height // 4),
													l_mark_width, bound.height // 2
												)
				else
					l_informations_width := la_text.width
				end
				a_renderer.draw_texture (la_text, bound.x + ((bound.width - l_informations_width) // 2), bound.y + ((bound.height - la_text.height) // 2))
			end
		end

	set_player_turn(a_o_turn:BOOLEAN)
			-- When the playing player change.If `a_o_turn' is set, the player O is playing,
			-- X if not set.
		do
			set_text("Player: ")
			if a_o_turn then
				image_player_texture := ressources_factory.o_image
			else
				image_player_texture := ressources_factory.x_image
			end
		end

	set_winner(a_o_winner:BOOLEAN)
			-- When a player win. If `a_o_winner' is set, the player O is the
			-- winner, X if not set.
		do
			set_text("Winner: ")
			if a_o_winner then
				image_player_texture := ressources_factory.o_image
			else
				image_player_texture := ressources_factory.x_image
			end
		end

	set_draw
			-- The game has ended because the {TIC_TAC_TOE_GRID} is full, but no player won
		do
			set_text("Draw!")
			image_player_texture := Void
		end



feature {NONE} -- Impementation

	ressources_factory:RESSOURCES_FACTORY
			-- Factory used to get ressources

	font:TEXT_FONT
			-- The font used to draw text in `Current'

	text_surface:detachable GAME_SURFACE
			-- The text to draw in `Current'

	text_texture:detachable GAME_TEXTURE
			-- an image texture representing `text_surface'

	image_player_texture:detachable GAME_TEXTURE
			-- If the text to `draw' need a reference to player, contain the player mark

	set_text(a_text:READABLE_STRING_GENERAL)
			-- Assign `a_text' to the text image `text_surface'
		local
			l_text:TEXT_SURFACE_SHADED
			l_forground_color, l_background_color: GAME_COLOR
		do
			text_texture := Void
			create l_forground_color.make_rgb (0, 0, 0)
			create l_background_color.make_rgb (255, 255, 255)
			create l_text.make (a_text, font, l_forground_color, l_background_color)
			text_surface := l_text
		end


end
