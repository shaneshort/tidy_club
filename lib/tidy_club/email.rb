module TidyClub
	class Email < ActiveResource::Base
		attr_accessor :id, :subject, :body, :created_at

		self.site = TidyClub.get_api_url
		ActiveResource::Base.headers['Authorization'] = "Bearer #{TidyClub.get_access_token}"
	end
end