module TidyClub
	class Group < TidyClub::Base

		# :id, :label, :description, :contacts_count, :logo_image, :created_at

		has_many :contacts, :class_name => 'TidyClub::Contact'
	end

	module HelperFunctions
		def group
			TidyClub::Group
		end
	end
end