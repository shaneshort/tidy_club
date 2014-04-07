module TidyClub
	class Membership < BaseObject

		attr_accessor :id, :start_date, :end_date, :state, :created_at, :contact_id, :membership_level_id, :child_bundle

		# returns a list of all members that are in tidy club
		def self.all
			ret = []
			TidyClub.get_api.make_request(TidyClub::Request::Memberships.new).each do |row|
				ret << Membership.new(row)
			end
			ret
		end


	end
end