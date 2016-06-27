note
	description: "An artifical intelligence that can play standard Tic Tac Toe"
	author: "Guillaume Jean"
	date: "Tue, 15 Dec 2015 00:42:19 +0000"
	revision: "1.0"

class
	TIC_TAC_TOE_AI

inherit
	AI
		redefine
			make
		end

create
	make

feature {NONE}
	make(a_is_o: BOOLEAN)
		do
			Precursor(a_is_o)
			create {LINKED_TREE[TUPLE[value, action: INTEGER]]} experience.make([0, 0])
			create {LINKED_LIST[INTEGER]} past_actions.make
		end


feature {NONE}
	gamma: REAL = 0.8
		-- Learning factor from previous experiences
	experience: LINKED_TREE[TUPLE[value, action: INTEGER]]
		-- Tree containing all learned informations from previous experiences
	past_actions: LINKED_LIST[INTEGER]
		-- List of all actions that led to current_state

feature -- Access
	play(a_grid:TIC_TAC_TOE_GRID)
			-- <Precursor>
		local
			l_current_state: INTEGER
			l_next_state: TUPLE[value, index: INTEGER]
			l_next: TUPLE[x, y: INTEGER]
		do
			--l_current_state := detect_state(a_grid)
			--l_next_state := max_tree(experience)
			--past_actions.extend(l_next_state.index)
			--print(l_current_state)
			--print(" ~ ")
			--print(l_next_state.value)
			--l_next := find_next(a_grid, l_next_state.index)
			l_next := find_next(a_grid, 0)
			print(" ~~> ")
			print(l_next.x.out + ", " + l_next.y.out)
			a_grid.select_cell (is_o, l_next.x, l_next.y)
			io.put_new_line
		end

feature -- Used methods
	detect_state(a_grid:TIC_TAC_TOE_GRID):INTEGER
		local
			i: INTEGER
			j: INTEGER
			l_index: INTEGER
			l_contenu: INTEGER
		do
			l_index := 0
			from
				i := 1
			until
				i > a_grid.items.count
			loop
				from
					j := 1
				until
					j > a_grid.items.at(i).count
				loop
					if attached a_grid.items.at(i).at(j) as l_item then
						if l_item.is_o then
							l_contenu := 2
						else
							l_contenu := 1
						end
					else
						l_contenu := 0
					end
					l_index := l_index + l_contenu * (3 ^ (3*(i-1) + (j-1))).rounded
					j := j + 1
				end
				io.put_new_line
				i := i + 1
			end

			Result := l_index
		end

	max_tree(a_tree:LINKED_TREE[TUPLE[value, action: INTEGER]]): TUPLE[value, index: INTEGER]
		local
			l_max: INTEGER
			l_index: INTEGER
			l_result: TUPLE[value, index: INTEGER]
		do
			a_tree.child_start
			if a_tree.child_readable and not a_tree.child_off then
				l_max := a_tree.child_item.value
				from
					a_tree.child_start
				until
					a_tree.child_after
				loop
					if a_tree.child_item.value > l_max then
						l_max := a_tree.child_item.value
						l_index := a_tree.child_index
					end
					a_tree.child_forth
				end
				l_result := [l_max, l_index]
			else
				l_result := [-1, -1]
			end

			Result := l_result
		end

	find_next(a_grid:TIC_TAC_TOE_GRID; a_next_state:INTEGER): TUPLE[x, y:INTEGER]
		do

			Result := [1, 1]
		end

invariant
	gamma >= 0
	gamma <= 1
end
