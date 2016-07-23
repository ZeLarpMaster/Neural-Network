note
	description: "Implementation of math functions"
	author: "Guillaume Jean"
	date: "2016-06-29"
	revision: "16w26"

class
	MATH_UTILITY

inherit
	DOUBLE_MATH

feature -- Access

	sigmoid(a_number: REAL_64): REAL_64
			-- Implementation of the sigmoid function
		do
			Result := 1 / (1 + (Euler ^ -a_number))
		end

	sigmoid_prime(a_number: REAL_64): REAL_64
			-- Derivative of the sigmoid function
		do
			Result := sigmoid(a_number) * (1 - sigmoid(a_number))
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

end
