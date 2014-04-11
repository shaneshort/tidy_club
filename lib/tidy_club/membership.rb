module TidyClub
	class Membership < TidyClub::Base

		# :id, :start_date, :end_date, :state, :created_at, :contact_id, :membership_level_id, :child_bundle

	end
	module HelperFunctions
		def membership
			TidyClub::Membership
		end
	end
end