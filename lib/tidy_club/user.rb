module TidyClub
	class User < TidyClub::Base
	end
	module HelperFunctions
		def user
			TidyClub::User
		end
	end
end