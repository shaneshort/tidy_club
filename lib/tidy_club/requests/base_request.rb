module TidyClub
  module Request
    class BaseRequest
      def initialize
        @params = {}
      end

      # Adds a parameter to the URI
      # @param [String] the param key
      # @param [String] the value for the parameter
      def add_parameter(key, value)
        @params[key] = value
      end

      def get_payload
        raise RuntimeError, "Stop being lazy, implement the payload"
      end

      # gets the URI of the API endpoint to call
      # @return [String]
      def get_uri
        uri = get_club_base_api_url(TidyClub.get_club_name) << "?"
        @params.each do |key, value|
          uri << "#{key}=#{value}"
        end
        uri
      end

      # returns the tidy club URL that we can use to make our API calls
      # @param [String] club_name The name of the club we want a URL
      # @return [String] URI
      def get_club_base_api_url(club_name)
        # get the part of the class name after "TidyClub::Request::"
        method = self.class.to_s.sub('TidyClub::Request::', '').downcase
        "https://#{club_name}.tidyclub.com/api/v1/#{method}"
      end
    end
  end
end