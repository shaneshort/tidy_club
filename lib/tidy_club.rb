require 'tidy_club/version'

require 'logger'
require 'tmpdir'
require 'active_resource'
require 'uri'
require 'net/https'

module TidyClub

	@logger_level = Logger::Severity::WARN

	# Call this function to first setup any privileged access you may have
	# @param [String] club_name The name of your club
	# @param [String] client_id The Client ID fetched from Tidyclub -> Settings -> Applications
	# @param [String] secret The secret fetched from Tidyclub -> Settings -> Applications
	# @param [String] user_name Your login to TidyClub
	# @param [String] password Your Password to TidyClub
	def self.setup(club_name, client_id, secret, user_name, password)
		@club_name       = club_name
		@client_id       = client_id
		@secret          = secret
		@user_name       = user_name
		@password        = password
		@logger          = Logger.new STDERR
		@logger.progname = 'TidyClub'
		@logger.level    = @logger_level

		@logger.debug 'Requiring end points'
		require 'tidy_club/base'
		require 'tidy_club/category'
		require 'tidy_club/club'
		require 'tidy_club/task'
		require 'tidy_club/membership'
		require 'tidy_club/contact'
		require 'tidy_club/deposit'
		require 'tidy_club/email'
		require 'tidy_club/ticket'
		require 'tidy_club/payment'
		require 'tidy_club/event_payment'
		require 'tidy_club/event'
		require 'tidy_club/expense'
		require 'tidy_club/group'
		require 'tidy_club/invoice'
		require 'tidy_club/meeting'
		require 'tidy_club/membership_level'
		require 'tidy_club/user'

		set_auth_header get_access_token

		nil
	end


	# returns the logger that is common to all of our logging
	# @return [Logger] our common logger object
	def self.logger
		@logger
	end

	# allows a user to set the debug output level on the in built logger
	# @param [int] level one of the Logger::Severity levels
	def self.set_logger_level(level)
		@logger_level = level
		@logger.level = level unless @logger.nil?
	end



	# helper func to return the url of the API for the given club
	# @return [String]
	def self.get_api_url
		"https://#{@club_name}.tidyclub.com/api/v1/"
	end


	# Nukes the existing authentication token and performs the authentication step again
	def self.reauthenticate
		nuke_auth_token
		set_auth_header get_access_token
	end


	private

	# Nuke the existing authentication token from orbit.
	# Use only if you have a stale/invalid auth token.
	# i.e. You are getting 4xx HTTP errors - ActiveResource::UnauthorizedAccess
	def self.nuke_auth_token
		file = get_access_token_file
		@logger.info "Removing persisted access token: #{file}"
		File.delete file
		set_access_token(nil)
		set_auth_header ''
	end

	# puts our authentication token in the request header
	# @param [String] The auth token
	def self.set_auth_header(token)
		ActiveResource::Base.headers['Authorization'] = "Bearer #{token}"
		nil
	end

	# helper func that gives us the file name of the persistent access token store
	# @return [String]
	def self.get_access_token_file
		sprintf('%s/%s-tidyclub-oauth-token', Dir.tmpdir, @club_name)
	end

	# sets the access token to use, writes it to disk
	# @param [String] token The access token
	def self.set_access_token(token)
		@logger.info "Setting access token to #{token}"
		@access_token = token
		File.write(get_access_token_file, @access_token) unless (@access_token.nil? || @access_token == '')
		nil
	end

	# gets the access token for communicating with the API
	# @return [String]
	def self.get_access_token
		if @access_token.nil?
			# do we have it cached on disk?
			tmp_file = get_access_token_file

			if File.exist? tmp_file
				@logger.info 'Fetching cached auth token from disk'
				set_access_token(File.read(tmp_file).strip)
			end
		end

		# try again, get a fresh token
		if @access_token.nil?
			uri = URI("https://#{@club_name}.tidyclub.com/oauth/token")
			@logger.info "Fetching a fresh token from #{uri}"
			https         = Net::HTTP.new(uri.host, uri.port)
			https.use_ssl = true
			payload       = {
					client_id:     @client_id,
					client_secret: @secret,
					username:      @user_name,
					password:      @password,
					grant_type:    'password'
			}
			request       = Net::HTTP::Post.new(uri.path)

			request.set_form_data payload
			response = https.request(request)

			if response.content_type != 'application/json'
				msg = "Expecting a JSON response, got a response type of '#{response.content_type}' instead"
				@logger.error msg
				raise TidyClub::ApiCallBad, msg
			end

			if response.code.to_i == 200
				r = JSON.parse response.body
				set_access_token r['access_token']
			else
				msg = "Authentication Failed - response code was: #{response.code} - #{response.message}"
				@logger.error msg
				raise TidyClub::ApiCallBad, msg
			end
		end
		@access_token = nil if @access_token == ''

		if @access_token.nil?
			msg = 'There is no valid access token'
			@logger.error msg
			raise AuthenticationError, msg
		end

		@access_token
	end


	class AuthenticationError < Exception

	end

	class ApiCallBad < Exception

	end


end

