require "tidy_club/version"
require "tidy_club/member"
require "tidy_club/requests/base_request"
require "tidy_club/requests/authentication"
require "tidy_club/requests/member"

require 'logger'
require 'json'
require 'uri'
require 'net/https'

module TidyClub
  # Call this function to first setup any privileged access you may have
  # @param club_name string
  # @param client_id string
  # @param secret string
  def self.setup(club_name, client_id, secret, user_name, password)
    @club_name = club_name
    @client_id = client_id
    @secrect = secret
    @user_name = user_name
    @password = password
    @logger = Logger.new STDOUT
    @api = TidyClub::Api.new
  end

  ## below here are internal functions

  def self.logger
    @logger
  end

  def self.get_club_url(club_name)
    "https://#{club_name}.tidyclub.com/api/v1?"
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

      uri = rq.get_uri

      #Net::HTTP::Client
    end

    def do_request(rq)
      TidyClub.logger.debug rq.inspect
      uri = URI(rq.get_uri)
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true

      request = Net::HTTP::Post.new(uri.path)
      request["Authorization"] = "Bearer #{@auth_token}" if @auth_token

      payload = rq.get_payload

      if payload.nil?
        request.set_form_data payload
        TidyClub.logger.debug "Making a GET request"
      else
        TidyClub.logger.debug "Making a post request"
      end

      JSON.parse https.request(request)
    end
  end


end
