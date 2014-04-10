module TidyClub
	class Event < TidyClub::Base
		has_many :tickets, class_name: 'TidyClub::Ticket'
		has_many :payments, class_name: 'TidyClub::Payment'
	end
end