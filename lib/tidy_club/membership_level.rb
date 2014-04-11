module TidyClub
	class MembershipLevel < TidyClub::Base
		has_many :memberships, class_name: 'TidyClub::Membership'
	end
	module HelperFunctions
		def membership_level
			TidyClub::MembershipLevel
		end
	end
end