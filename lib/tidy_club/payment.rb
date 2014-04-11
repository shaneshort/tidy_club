module TidyClub
	class Payment < TidyClub::Base
	end
	module HelperFunctions
		def payment
			TidyClub::Payment
		end
	end
end