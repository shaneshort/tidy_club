module TidyClub
	class MembershipLevel < TidyClub::Base
		has_many :memberships, class_name: 'TidyClub::Membership'
	end
end