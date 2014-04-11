module TidyClub
	class Category < TidyClub::Base
	end

	module HelperFunctions
		def category
			TidyClub::Category
		end
	end
end