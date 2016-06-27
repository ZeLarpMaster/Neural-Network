note
	description: "Factory that generate every ressources of the game"
	author: "Louis Marchand"
	date: "Sun, 06 Dec 2015 22:12:04 +0000"
	revision: "1.0"

class
	RESSOURCES_FACTORY

create
	make

feature {NONE} -- Constants

	Ressources_directory:READABLE_STRING_GENERAL
			-- The directory (or sub-directory) containing the files
		once
			Result := "ressources"
		end

	Image_file_extension:READABLE_STRING_GENERAL
			-- The complete extension of the image files
		once
			Result := "png"
		end

	Font_file_extension:READABLE_STRING_GENERAL
			-- The complete extension of the font files
		once
			Result := "ttf"
		end

feature {NONE} -- Initialization

	make(a_renderer:GAME_RENDERER; a_format:GAME_PIXEL_FORMAT_READABLE)
			-- Initialization of `Current' using `a_renderer' and `a_format'
			-- to create default {GAME_TEXTURE}
		do
			has_error := False
			make_images(a_renderer, a_format)
		end

	make_images(a_renderer:GAME_RENDERER; a_format:GAME_PIXEL_FORMAT_READABLE)
			-- Initialization of every *_image using `a_renderer' and `a_format'
			-- to create default {GAME_TEXTURE}
		do
			if attached load_image(a_renderer, "x") as la_image then
				x_image := la_image
			else
				create x_image.make (a_renderer, a_format, 1, 1)
				has_error := True
			end
			if not has_error and then attached load_image(a_renderer, "o") as la_image then
				o_image := la_image
			else
				create o_image.make (a_renderer, a_format, 1, 1)
				has_error := True
			end
			if not has_error and then attached load_image(a_renderer, "panel") as la_image then
				grid_image := la_image
			else
				create grid_image.make (a_renderer, a_format, 1, 1)
				has_error := True
			end
			if not has_error and then attached load_image(a_renderer, "win") as la_image then
				winning_image := la_image
			else
				create winning_image.make (a_renderer, a_format, 1, 1)
				has_error := True
			end
		end

feature -- Access

	x_image:GAME_TEXTURE
			-- The image texture that represent the X mark

	o_image:GAME_TEXTURE
			-- The image texture that represent the O mark

	grid_image:GAME_TEXTURE
			-- The image texture that represent the game grid

	winning_image:GAME_TEXTURE
			-- The image texture that is put on the panel when a player has won

	informations_font(a_size:INTEGER):TEXT_FONT
			-- The font used in the {INFORMATIONS_PANEL}
		local
			l_path:PATH
		do
			create l_path.make_from_string (Ressources_directory)
			l_path := l_path.extended ("font")
			l_path := l_path.appended_with_extension (Font_file_extension)
			create Result.make (l_path.name, a_size)
			if Result.is_openable then
				Result.open
			end
		ensure
			Is_Open: Result.is_open
		end

	has_error:BOOLEAN
			-- An error occured at creation

feature {NONE} -- Implementation

	load_image(a_renderer:GAME_RENDERER; a_name:READABLE_STRING_GENERAL):detachable GAME_TEXTURE
			-- Create a {GAME_TEXTURE} from an image file identified by `a_name'
		local
			l_image:IMG_IMAGE_FILE
			l_path:PATH
		do
			Result := Void
			create l_path.make_from_string (Ressources_directory)
			l_path := l_path.extended (a_name)
			l_path := l_path.appended_with_extension (Image_file_extension)
			create l_image.make (l_path.name)
			if l_image.is_openable then
				l_image.open
				if l_image.is_open then
					create Result.make_from_image (a_renderer, l_image)
					if Result.has_error then
						Result := Void
					end
				end
			end
		ensure
			Image_Exist: attached Result
		end

end
