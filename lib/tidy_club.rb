require 'tidy_club/version'
require 'tidy_club/base_object'
require 'tidy_club/membership'
require 'tidy_club/requests/base_request'
require 'tidy_club/requests/authentication'
require 'tidy_club/requests/memberships'

require 'logger'
require 'json'
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
    @club_name = club_name
    @client_id = client_id
    @secret = secret
    @user_name = user_name
    @password = password
    @logger = Logger.new STDOUT
    @logger.progname = 'TidyClub'

    @api = TidyClub::Api.new
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

  class Api
    @auth_token = nil


    def make_request(rq)
      # are we authenticated
      authenticate unless @auth_token

      do_request rq
    end

    private

    def authenticate
      rq = TidyClub::Request::Authentication.new(
          TidyClub.get_club_name,
          TidyClub.get_client_id,
          TidyClub.get_client_secret,
          TidyClub.get_user_name,
          TidyClub.get_password
      )

      rs = do_request rq
      @auth_token = rs['access_token']
    end

    # @param [#get_uri, #get_payload] rq The request to process
    def do_request(rq)
	    raise TidyClub::TidyClubApiCallBad, 'The request does not implement a #get_uri function' unless rq.respond_to? :get_uri
	    raise TidyClub::TidyClubApiCallBad, 'The request does not implement a #get_payload function' unless rq.respond_to? :get_payload

      uri = URI(rq.get_uri)
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true

      payload = rq.get_payload

      if payload.nil?
	      request = Net::HTTP::Get.new(uri.path)
        TidyClub.logger.debug "Making a GET request for #{rq.class} to #{uri}"
      else
	      request = Net::HTTP::Post.new(uri.path)
	      request.set_form_data payload
        TidyClub.logger.debug "Making a POST request for #{rq.class} to #{uri}"
      end

	    request['Authorization'] = "Bearer #{@auth_token}" if @auth_token

	    response = https.request(request)

	    TidyClub.logger.debug " -> Response Type = #{response.content_type}"

	    if response.content_type != 'application/json'
		    raise TidyClub::TidyClubApiCallBad, "Expecting a JSON response, got a response type of '#{response.content_type}' instead"
	    end

	    TidyClub.logger.info response.body

	    if response.code.to_i == 200
		    return JSON.parse response.body
	    else
				if response.class::HAS_BODY
					r = JSON.parse response.body
					TidyClub.logger.error "The request to #{uri} failed with error #{response.code} - #{response.message}"
					TidyClub.logger.error "Payload: #{rq.get_payload}"
					TidyClub.logger.error r['error']
					TidyClub.logger.error r['error_description']
				end
				raise TidyClub::TidyClubApiCallBad, "Request was bad - response code was: #{response.code} - #{response.message}"
	    end


    end
  end

	class TidyClubApiCallBad < Exception

	end


end
