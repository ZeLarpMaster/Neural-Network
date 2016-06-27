note
	description: "Implementation of a network of neurons with X layers of Y neurons"
	author: "Guillaume Jean"
	date: "2016-06-27"
	revision: "16w26"

class
	NEURAL_NETWORK

create
	make

feature {NONE}
	make(a_layers_count: LIST[INTEGER])
		require
			More_Than_One_Layer: a_layers_count.count > 1
		local
			l_layer_content: ARRAYED_LIST[NEURON]
			l_neuron: NEURON
			l_previous_output_count: INTEGER
			l_output: OUTPUT
			l_input: INPUT
		do
			l_previous_output_count := 1
			create {ARRAYED_LIST[ARRAYED_LIST[NEURON]]} layers.make(a_layers_count.count)
			from
				a_layers_count.start
			until
				a_layers_count.exhausted
			loop
				create l_layer_content.make(a_layers_count.item)
				across 1 |..| a_layers_count.item as la_neurons loop
					random_sequence.forth
					if a_layers_count.islast then
						create l_output.make(0)
					else
						create {HOOKED_OUTPUT} l_output.make(0)
					end
					create l_neuron.make_sigmoidal(random_sequence.double_item, l_output, l_previous_output_count)
					across 1 |..| l_previous_output_count as la_previous_output_count loop
						if a_layers_count.isfirst then
							create l_input.make(0)
						else
							create {INPUT_CONNECTION} l_input.make(0)
							if
								attached {HOOKED_OUTPUT} layers.at(a_layers_count.index - 1).at(la_previous_output_count.item).output as la_output and
								attached {INPUT_CONNECTION} l_input as la_input
							then
								la_output.connections.extend(la_input)
							end
						end
						l_neuron.inputs.extend(l_input)
					end
					l_layer_content.extend(l_neuron)
				end

				layers.extend(l_layer_content)
				a_layers_count.forth
			end
		end

feature {NONE}
	random_sequence: RANDOM
			-- Returns a new random sequence
		local
			l_time: TIME
			l_seed: INTEGER
		once
			create l_time.make_now
			l_seed := l_time.hour
			l_seed := l_seed * 60 + l_time.minute
			l_seed := l_seed * 60 + l_time.second
			l_seed := l_seed * 1000 + l_time.milli_second
			create Result.set_seed (l_seed)
		end

feature {NONE} -- Implementation

	learning_rate: REAL_64 = 0.75
			-- Learning rate of the network. Might become an argument to make.

feature -- Access

	layers: LIST[LIST[NEURON]]
			-- Actual layers

	learn_back_propagate(a_input, a_expected_output: LIST[REAL_64])
			-- Make the network learn the `a_input', `a_expected_output' pair
			-- TODO: HOW DO I MAKE IT LEARN TO PLAY AND NOT TO LEARN BY HEART HOW TO PLAY
			-- Wi,j = Wi,j + learning * outputj * deltaj
			-- Error = 0.5 * (expected output - actual output) ^ 2
		local
			l_neuron_weights: LINKED_LIST[TUPLE[weight, input: REAL_64]]
			l_current_output: ARRAYED_LIST[REAL_64]
			l_desired_output: ARRAYED_LIST[REAL_64]
			l_output_delta: ARRAYED_LIST[REAL_64]
		do
			feed_forward(a_input)
		end

	feed_forward(a_input: LIST[REAL_64])
			-- Calculate the activation of each neuron from the output of the previous layer using `a_input' as input
			-- TODO: Redo this ^
		require
			Input_Count_Equals_Input_Count: a_input.count = layers.at(1).count
		do
			from
				layers.first.start
				a_input.start
			until
				layers.first.exhausted or a_input.exhausted
			loop
				layers.first.item.inputs.first.set_value(a_input.item)
				layers.first.forth
				a_input.forth
			end
			from
				layers.go_i_th(2)
			until
				layers.exhausted
			loop
				from
					layers.item.start
				until
					layers.item.exhausted
				loop
					layers.item.item.update_output
					layers.item.forth
				end
				layers.forth
			end
		end

	matrix_product_vector(a_matrix: LIST[LIST[REAL_64]]; a_vector: LIST[REAL_64]): LIST[REAL_64]
		require
			Matrix_Width_Equals_Vector_Size: across a_matrix as la_matrix all la_matrix.item.count = a_vector.count end
		do
			create {ARRAYED_LIST[REAL_64]} Result.make_filled(a_vector.count)
			across a_matrix as la_matrix loop
				from
					a_matrix.item.start
					a_vector.start
					Result.start
				until
					a_matrix.item.exhausted or a_vector.exhausted or Result.exhausted
				loop
					Result.replace(Result.item + (la_matrix.item.item * a_vector.item))
					a_matrix.item.forth
					a_vector.forth
					Result.forth
				end
				a_matrix.forth
			end
		end

	hadamard_product(a_vector1, a_vector2: LIST[REAL_64]): LIST[REAL_64]
			-- Result[i] = `a_vector1'[i] * `a_vector2'[i]
		require
			Vectors_Same_Size: a_vector1.count = a_vector2.count
		do
			create {ARRAYED_LIST[REAL_64]} Result.make(a_vector1.count)
			from
				a_vector1.start
				a_vector2.start
			until
				a_vector1.exhausted or a_vector2.exhausted
			loop
				Result.extend(a_vector1.item * a_vector2.item)
				a_vector1.forth
				a_vector2.forth
			end
		end

invariant
	More_Than_One_Layer: layers.count > 1
	Input_Layer_Has_One_Input: layers.first.for_all(agent (a_neuron: NEURON): BOOLEAN do Result := a_neuron.inputs.count = 1 end)
end
