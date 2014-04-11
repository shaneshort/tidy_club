module TidyClub
	class Invoice < TidyClub::Base
	end
	module HelperFunctions
		def invoice
			TidyClub::Invoice
		end
	end
end