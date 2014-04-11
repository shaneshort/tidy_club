module TidyClub
	class Meeting < TidyClub::Base
	end
	module HelperFunctions
		def meeting
			TidyClub::Meeting
		end
	end
end