module TidyClub
	class BaseObject
		def initialize(data)
			data.each do |k, v|
				method = "#{k}="
				if self.respond_to?(method)
					self.send(method, v)
				end
			end
		end

	end
end