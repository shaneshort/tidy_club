module TidyClub
	module Auth

		# Nukes the existing authentication token and performs the authentication step again
		def reauthenticate
			nuke_auth_token
			set_auth_header get_access_token
		end

		private

		# Nuke the existing authentication token from orbit.
		# Use only if you have a stale/invalid auth token.
		# i.e. You are getting 4xx HTTP errors - ActiveResource::UnauthorizedAccess
		def nuke_auth_token
			file = get_access_token_file
			@logger.info "Removing persisted access token: #{file}"
			File.delete file
			set_access_token(nil)
			set_auth_header ''
		end

		# puts our authentication token in the request header
		# @param [String] token The auth token
		def set_auth_header(token)
			ActiveResource::Base.headers['Authorization'] = "Bearer #{token}"
			nil
		end

		# helper func that gives us the file name of the persistent access token store
		# @return [String]
		def get_access_token_file
			sprintf('%s/%s-tidyclub-oauth-token', Dir.tmpdir, @club_name)
		end

		# sets the access token to use, writes it to disk
		# @param [String] token The access token
		def set_access_token(token)
			@logger.info "Setting access token to #{token}"
			@access_token = token
			File.write(get_access_token_file, @access_token) unless (@access_token.nil? || @access_token == '')
			nil
		end

		# gets the access token for communicating with the API
		# @return [String]
		def get_access_token
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
						client_id:     client_id,
						client_secret: client_secret,
						username:      user_name,
						password:      password,
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
	end
end