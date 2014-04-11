module TidyClub
	class Base < ActiveResource::Base
		self.site = TidyClub.get_api_url
		self.logger = TidyClub.logger
	end
end