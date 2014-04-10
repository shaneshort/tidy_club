require 'tidy_club/version'

require 'logger'
require 'tmpdir'
require 'active_resource'
require 'uri'
require 'net/https'

module TidyClub
	# Call this function to first setup any privileged access you may have
	# @param [String] club_name The name of your club
	# @param [String] client_id The Client ID fetched from Tidyclub -> Settings -> Applications
	# @param [String] secret The secret fetched from Tidyclub -> Settings -> Applications
	# @param [String] user_name Your login to TidyClub
	# @param [String] password Your Password to TidyClub
	# @return [TidyClub::Api] You do not really need this, but it is there just in case
	def self.setup(club_name, client_id, secret, user_name, password)
		@club_name       = club_name
		@client_id       = client_id
		@secret          = secret
		@user_name       = user_name
		@password        = password
		@logger          = Logger.new STDOUT
		@logger.progname = 'TidyClub'

		require 'tidy_club/base'
		require 'tidy_club/club'
		require 'tidy_club/contact'
		require 'tidy_club/email'
		require 'tidy_club/group'
		require 'tidy_club/membership'
		require 'tidy_club/meeting'
	end

	## below here are internal functions

	def self.logger
		@logger
	end

	def self.get_club_name
		@club_name
	end

	def self.get_client_id
		@client_id
	end

	def self.get_client_secret
		@secret
	end

	def self.get_user_name
		@user_name
	end

	def self.get_password
		@password
	end

	def self.get_api
		@api
	end

	def self.get_api_url
		"https://#{@club_name}.tidyclub.com/api/v1/"
	end

	def self.get_access_token_file
		sprintf('%s/%s-tidyclub-oauth-token', Dir.tmpdir, @club_name)
	end

	def self.set_access_token(token)
		@access_token = token
		File.write(TidyClub.get_access_token_file, @access_token)
	end

	def self.get_access_token
		if @access_token.nil?
			# do we have it cached on disk?
			tmp_file = TidyClub.get_access_token_file

			if File.exist? tmp_file
				TidyClub.set_access_token(File.read(tmp_file).strip)
			end
		end

		# try again, get a fresh token
		if @access_token.nil?
			TidyClub.logger.debug 'Fetching a fresh token'
			uri           = URI("https://#{TidyClub.get_club_name}.tidyclub.com/oauth/token")
			https         = Net::HTTP.new(uri.host, uri.port)
			https.use_ssl = true
			payload       = {
					client_id:     TidyClub.get_client_id,
					client_secret: TidyClub.get_client_secret,
					username:      TidyClub.get_user_name,
					password:      @password,
					grant_type:    'password'
			}
			request       = Net::HTTP::Post.new(uri.path)
			request.set_form_data payload
			response = https.request(request)
			if response.content_type != 'application/json'
				raise TidyClub::TidyClubApiCallBad, "Expecting a JSON response, got a response type of '#{response.content_type}' instead"
			end

			if response.code.to_i == 200
				r = JSON.parse response.body
				TidyClub.set_access_token r[:access_token]
			else
				raise TidyClub::TidyClubApiCallBad, "Authentication Failed - response code was: #{response.code} - #{response.message}"
			end
		end


		@access_token
	end


	class TidyClubApiCallBad < Exception

	end


end

