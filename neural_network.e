note
	description: "Implementation of a network of neurons with X layers of Y neurons"
	author: "Guillaume Jean"
	date: "2016-06-27"
	revision: "16w26"

class
	NEURAL_NETWORK

inherit
	MATH_UTILITY

create
	make

feature {NONE} -- Initialization

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
				l_previous_output_count := a_layers_count.item
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

	use_network(a_input: LIST[REAL_64]): LIST[REAL_64]
			-- Use the neural network with input `a_input' and returns the output
		do
			feed_forward(a_input)
			create {ARRAYED_LIST[REAL_64]} Result.make(layers.last.count)
			from
				layers.last.start
			until
				layers.last.exhausted
			loop
				Result.extend(layers.last.item.output.value)
				layers.last.forth
			end
		end

	learn_back_propagate(a_input, a_expected_output: LIST[REAL_64])
			-- Make the network learn the `a_input', `a_expected_output' pair
		require
			Inputs_Network_Size: a_expected_output.count = layers.last.count
		do
			feed_forward(a_input)
			backpropagate_error(a_expected_output)
		end

	backpropagate_error(a_expected_output: LIST[REAL_64])
			-- Propagates the output error compared to `a_expected_output' from the end to the layer 2 of the network
		require
			Outputs_Network_Size: a_expected_output.count = layers.last.count
		local
			l_previous_layer_error: LIST[REAL_64]
			l_all_errors: LIST[LIST[REAL_64]]
		do
			create {ARRAYED_LIST[LIST[REAL_64]]} l_all_errors.make(layers.count)
			l_previous_layer_error := calculate_output_error(a_expected_output)
			l_all_errors.extend(l_previous_layer_error)
			from
				layers.go_i_th(layers.count - 1)
			until
				layers.index < 2
			loop
				l_previous_layer_error := neuron_layer_error(layers.item, l_previous_layer_error)
				l_all_errors.extend(l_previous_layer_error)
				layers.back
			end
		end

	calculate_output_error(a_expected_output: LIST[REAL_64]): LIST[REAL_64]
			-- Calculates and returns the error of the output
			-- Side effect: modifies the layer's neurons' weight and bias
		require
			Outputs_Network_Size: a_expected_output.count = layers.last.count
		local
			l_delta_output, l_sigmoid_prime, l_error: REAL_64
		do
			create {ARRAYED_LIST[REAL_64]} Result.make(layers.last.count)
			from
				a_expected_output.start
				layers.last.start
			until
				a_expected_output.exhausted or layers.last.exhausted
			loop
				l_delta_output := layers.last.item.output.value - a_expected_output.item
				l_sigmoid_prime := sigmoid_prime(layers.last.item.weighted_total_input)
				l_error := l_delta_output * l_sigmoid_prime
				adjust_neuron(layers.last.item, l_error)
				Result.extend(l_error)
				a_expected_output.forth
				layers.last.forth
			end
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

	neuron_layer_error(a_neuron_layer: LIST[NEURON]; a_previous_error: LIST[REAL_64]): LIST[REAL_64]
			-- Calculates `a_neuron_layer's error using the previous layer's error `a_previous_error'
			-- Side effect: modifies the layer's neurons' weight and bias
		require
			Matrix_Width_Equals_Vector_Size: across a_neuron_layer as la_layer all
					attached {HOOKED_OUTPUT} la_layer.item.output as la_output implies la_output.connections.count = a_previous_error.count
				end
		do
			create {ARRAYED_LIST[REAL_64]} Result.make_filled(a_neuron_layer.count)
			Result.start
			across a_neuron_layer as la_layer loop
				if attached {HOOKED_OUTPUT} la_layer.item.output as la_output then
					from
						la_output.connections.start
						a_previous_error.start
					until
						la_output.connections.exhausted or a_previous_error.exhausted
					loop
						Result.replace(Result.item + (la_output.connections.item.weight * a_previous_error.item))
						la_output.connections.forth
						a_previous_error.forth
					end
				end
				Result.replace(Result.item * sigmoid_prime(la_layer.item.weighted_total_input))
				adjust_neuron(la_layer.item, Result.item)
				Result.forth
			end
		end

	adjust_neuron(a_neuron: NEURON; a_error: REAL_64)
			-- Adjusts the neuron `a_neuron's bias and weight using the error `a_error'
		do
			across a_neuron.inputs as la_inputs loop
				if attached {INPUT_CONNECTION} la_inputs.item as la_input then
					la_input.set_weight(la_input.weight + learning_rate * la_input.weighted_input * a_error)
				end
			end
			a_neuron.bias := a_neuron.bias + learning_rate * a_error
		end

invariant
	More_Than_One_Layer: layers.count > 1
	Input_Layer_Has_One_Input: layers.first.for_all(agent (a_neuron: NEURON): BOOLEAN do Result := a_neuron.inputs.count = 1 end)
end
