note
	description: "Neural Network example usage"
	date: "2016-07-03"
	revision: "16w27"

class
	APPLICATION

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			l_neural_network: NEURAL_NETWORK
		do
			create l_neural_network.make(create {ARRAYED_LIST[INTEGER]}.make_from_array(<<2, 2>>))
		end

end
