require 'tidy_club/version'

require 'logger'
require 'tmpdir'
require 'active_resource'
require 'uri'
require 'net/https'

require 'tidy_club/auth'
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


module TidyClub

	@logger_level = Logger::Severity::WARN

	class Client
		include TidyClub::Auth
		include TidyClub::HelperFunctions

		attr_accessor :club_name, :client_id, :client_secret, :user_name, :password, :logger_level

		# @example Example Setup
		#   client = TidyClub::Client.new |config| do
		#     config.club_name = 'your-club'
		#     config.client_id = 'club id from tidy club'
		#     config.client_secret = 'club secret'
		#     config.user_name = 'your username'
		#     config.password = 'your password'
		#     config.logger_level = Logger::Severity::Warn
		#   end
		# @param [Hash] options keys are: :club_name, :client_id, :client_secret, :user_name, :password, :logger_level
		# @return [TidyClub::Client]
		def initialize(options = {})
			# now setup our logger
			@logger = TidyClub.logger

			options.each do |key, value|
				@logger.debug "Setting :#{key}=#{value}"
				send(:"#{key}=", value)
			end
			yield(self) if block_given?


			# setup the ActiveResource stuff
			Base.site = get_api_url
			Base.logger = @logger
			set_auth_header get_access_token
		end

		# helper func to return the url of the API for the given club
		# @return [String]
		def get_api_url
			"https://#{club_name}.tidyhq.com/api/v1/"
		end


	end


	class AuthenticationError < Exception

	end

	class ApiCallBad < Exception

	end

	# returns the logger that is common to all of our logging
	# @return [Logger] our common logger object
	def self.logger
		if @logger.nil?
			@logger          = Logger.new STDERR
			@logger.progname = 'TidyClub'
			@logger.level    = @logger_level
		end

		@logger
	end

	# allows a user to set the debug output level on the in built logger
	# @param [int] level one of the Logger::Severity levels
	def self.set_logger_level(level)
		@logger_level = level
		@logger.level = level unless @logger.nil?
	end


end

