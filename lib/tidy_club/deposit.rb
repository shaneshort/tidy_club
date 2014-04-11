module TidyClub
	class Deposit < TidyClub::Base
	end

	module HelperFunctions
		def deposit
			TidyClub::Deposit
		end
	end

end