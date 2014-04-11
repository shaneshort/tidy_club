module TidyClub
	class Task < TidyClub::Base
	end

	module HelperFunctions
		def task
			TidyClub::Task
		end
	end
end