module TidyClub
	class Membership < BaseObject

		attr_accessor :id, :start_date, :end_date, :state, :created_at, :contact_id, :membership_level_id, :child_bundle

		# returns a list of all members that are in tidy club
    # @param [Boolean] active_only Whether or not to show only active memberships
		def self.all(active_only = true)
			ret = []
      rq = TidyClub::Request::Memberships.new
      rq.add_parameter("active", true) if active_only
			TidyClub.get_api.make_request(rq).each do |row|
				ret << Membership.new(row)
			end
			ret
		end
	end
end