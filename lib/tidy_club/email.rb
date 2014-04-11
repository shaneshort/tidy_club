module TidyClub
	class Email < TidyClub::Base
		#:id, :subject, :body, :created_at
	end

	module HelperFunctions
		def email
			TidyClub::Email
		end
	end

end