module TidyClub
	class Club < TidyClub::Base
		include ActiveResource::Singleton
	end

	module HelperFunctions
		def club
			TidyClub::Request::Club
		end
	end
end