module TidyClub
	class Expense < TidyClub::Base
	end
	module HelperFunctions
		def expense
			TidyClub::Expense
		end
	end
end