module TidyClub
	class Contact < TidyClub::Base

		#:id, :first_name, :last_name, :nick_name, :company, :email_address, :phone_number,
		#:address1, :city, :state, :country, :post_code,
		#:gender, :birthday, :facebook, :twitter, :details, :profile_image,
		#:created_at

		has_many :tasks, class_name: 'TidyClub::Task'
		has_many :memberships, class_name: 'TidyClub::Membership'
	end

	module HelperFunctions
		def contact
			TidyClub::Contact
		end
	end
end