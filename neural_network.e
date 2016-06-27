note
	description: "Implementation of a network of neurons with X layers of Y neurons"
	author: "Guillaume Jean"
	date: "$Date$"
	revision: "$Revision$"

class
	NEURAL_NETWORK

create
	make

feature {NONE}
	make(a_layers: LINKED_LIST[INTEGER])
		local
			l_layer_content: ARRAYED_LIST[NEURON]
			l_neuron: NEURON
		do
			create {ARRAYED_LIST[ARRAYED_LIST[NEURON]]} layers.make(a_layers.count)
			create {LINKED_LIST[TUPLE[l, j, k: INTEGER; value: REAL_64]]} weights.make
			from
				a_layers.start
				layers.start
			until
				a_layers.after or layers.after
			loop
				create l_layer_content.make(a_layers.item)
				if a_layers.isfirst then
					across 1 |..| a_layers.item as la_neurons loop
						random_sequence.forth
						create {INPUT_NEURON} l_neuron.make_sigmoidal
						l_layer_content.put_i_th(l_neuron, la_neurons.item)
					end
				else
					across 1 |..| a_layers.item as la_neurons loop
						random_sequence.forth
						create {NEURON} l_neuron.make_sigmoidal(random_sequence.double_item)
						l_layer_content.put_i_th(l_neuron, la_neurons.item)
						a_layers.back
						across 1 |..| a_layers.item as la_neurons_l_minus loop
							random_sequence.forth
							weights.extend([layers.index, la_neurons.item, la_neurons_l_minus.item, random_sequence.double_item.abs])
						end
						a_layers.forth
					end
				end
				layers.put(l_layer_content)
				a_layers.forth
				layers.forth
			end
		end

feature {NONE}
	random_sequence: RANDOM
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

feature {NONE}
	layers: ARRAYED_LIST[ARRAYED_LIST[NEURON]]
		-- Actual layers
	weights: LINKED_LIST[TUPLE[l, j, k: INTEGER; value: REAL_64]]
		-- List of weights where each weight is a tuple of the direction(l -> j) and the value
	learning_rate: REAL_64 = 0.75
		-- Learning rate of the network. Might become an argument to make.

feature
	learn_back_propagate(x, y: LIST[REAL_64])
		-- X is input
		-- Y is expected output for X
		-- TODO: HOW DO I MAKE IT LEARN TO PLAY AND NOT TO LEARN BY HEART HOW TO PLAY
		-- Wi,j = Wi,j + learning * outputj * deltaj
		-- Error = 0.5 * (expected output - actual output) ^ 2
		local
			l_neuron_weights: LINKED_LIST[TUPLE[weight, input: REAL_64]]
			l_current_output: ARRAYED_LIST[REAL_64]
			l_desired_output: ARRAYED_LIST[REAL_64]
			l_output_delta: ARRAYED_LIST[REAL_64]
		do

		end

	calculate_activations
		local
			l_activations: AL_MATRIX
		do

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
end
