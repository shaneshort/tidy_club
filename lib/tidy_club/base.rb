module TidyClub
	class Base < ActiveResource::Base
		self.site = TidyClub.get_api_url
		ActiveResource::Base.headers['Authorization'] = "Bearer #{TidyClub.get_access_token}"
	end
end