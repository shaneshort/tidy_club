module TidyClub
	class Membership < ActiveResource::Base

		attr_accessor :id, :start_date, :end_date, :state, :created_at, :contact_id, :membership_level_id, :child_bundle

		self.site = TidyClub.get_api_url
		ActiveResource::Base.headers['Authorization'] = "Bearer #{TidyClub.get_access_token}"
	end
end