note
	description: "An {ENGINE} that show and manage a menu"
	author: "Louis Marchand"
	date: "Tue, 15 Dec 2015 00:42:19 +0000"
	revision: "1.0"

deferred class
	MENU

inherit
	ENGINE
		redefine
			make, run
		end

feature {NONE} -- Initialization

	make(a_window:GAME_WINDOW_RENDERED; a_ressources_factory:RESSOURCES_FACTORY)
			-- <Precursor>
		do
			selected_item := 0
			Precursor(a_window, a_ressources_factory)
			font := a_ressources_factory.informations_font (a_window.height // 10)
			create {LINKED_LIST[GAME_TEXTURE]}items.make
			update_items_dimensions
		end

feature -- Access

	has_error:BOOLEAN
			-- An error occured at the creation of `Current'

	run
			-- <Precursor>
		do
			selected_item := 0
			window.renderer.set_drawing_color (background_color)
			window.mouse_button_released_actions.extend (agent on_clicked)
			Precursor
		end

	selected_item:INTEGER

feature {NONE} -- Implementation

	on_redraw(a_timestamp:NATURAL_32)
			-- <Precursor>
		local
			l_dimension:TUPLE[x, y, width, height:INTEGER]
		do
			window.renderer.clear
			if attached title as la_title and attached title_dimension as la_dimension then
				window.renderer.draw_texture (la_title, la_dimension.x, la_dimension.y)
			end
			from
				items.start
			until
				items.exhausted
			loop
				l_dimension := items_dimension.at (items.index)
				window.renderer.draw_texture (items.item, l_dimension.x, l_dimension.y)
				items.forth
			end
			window.update
		end

	on_clicked(a_timestamp: NATURAL_32; a_mouse_state: GAME_MOUSE_BUTTON_RELEASED_STATE; a_nb_clicks: NATURAL_8)
			-- When the user clicked on the `window'
		do
			if a_mouse_state.is_left_button_released and a_nb_clicks = 1 then
				from
					items_dimension.start
				until
					items_dimension.exhausted
				loop
					if
						items_dimension.item.x < a_mouse_state.x and
						items_dimension.item.y < a_mouse_state.y and
						items_dimension.item.x + items_dimension.item.width > a_mouse_state.x and
						items_dimension.item.y + items_dimension.item.height > a_mouse_state.y
					then
						selected_item := items_dimension.index
						stop
					end
					items_dimension.forth
				end
			end
		end

	title:detachable GAME_TEXTURE
			-- Image of `Current's Title text

	title_dimension: detachable TUPLE[x, y, width, height:INTEGER]
			-- The position and dimension of `title'

	items:LIST[GAME_TEXTURE]
			-- Every images of `Current's item's text

	items_dimension:LIST[TUPLE[x, y, width, height:INTEGER]]
			-- The postion and dimension of every `items'

	font:TEXT_FONT
			-- The font used to create `items' and `title' text images

	set_title(a_name:READABLE_STRING_GENERAL)
			-- Set `title' with the value of `a_name'.
			-- Change also `title_dimension' and `items_dimension'
		local
			l_image:TEXT_SURFACE_SHADED
		do
			create l_image.make (a_name, font, foreground_color, background_color)
			if l_image.is_open then
				create title.make_from_surface (window.renderer, l_image)
			else
				has_error := True
			end
			update_items_dimensions
		end

	add_item(a_item_name:READABLE_STRING_GENERAL)
			-- Add a new elements in `items' using the text `a_item_name'.
			-- Change also `title_dimension' and `items_dimension'
		local
			l_image:TEXT_SURFACE_SHADED
		do
			create l_image.make (a_item_name, font, foreground_color, background_color)
			if l_image.is_open then
				items.extend (create {GAME_TEXTURE}.make_from_surface (window.renderer, l_image))
			else
				has_error := True
			end
			update_items_dimensions
		end

	update_items_dimensions
			-- Modify `title_dimension' and `items_dimension' depending of
			-- the values in `title' and `items'
		local
			l_inter_height, l_total_height, l_y, l_window_demi_width:INTEGER
		do
			create {ARRAYED_LIST[TUPLE[x, y, width, height:INTEGER]]}items_dimension.make(0)

			l_inter_height := window.height // 10
			l_window_demi_width := window.width // 2
			l_total_height := 0
			if attached title as la_title then
				l_total_height := l_total_height + la_title.height + l_inter_height
			end
			across items as la_items loop
				l_total_height := l_total_height + la_items.item.height + l_inter_height
			end
			l_total_height := l_total_height - l_inter_height
			l_y := (window.height // 2) - (l_total_height // 2)
			if attached title as la_title then
				title_dimension := [l_window_demi_width - (la_title.width // 2), l_y, la_title.width, la_title.height]
				l_y := l_y + la_title.height + l_inter_height
			end
			across items as la_items loop
				items_dimension.extend ([l_window_demi_width - (la_items.item.width // 2), l_y, la_items.item.width, la_items.item.height])
				l_y := l_y + la_items.item.height + l_inter_height
			end
		ensure
			Items_And_Dimension_Synchronzed: items.count = items_dimension.count
		end

	foreground_color:GAME_COLOR
			-- The color to show the text `title' and `items'
		once
			create Result.make_rgb (0, 0, 0)
		end

	background_color:GAME_COLOR
			-- The color to draw in the background.
		once
			create Result.make_rgb (255, 255, 255)
		end

invariant
	Items_And_Dimension_Synchronzed: items.count = items_dimension.count

end
