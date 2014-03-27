module TidyClub
  module Request

    # uses an AuthenticationRequest to do the actual communication
    class Authentication < TidyClub::Request::BaseRequest
      def initialize(club, client_id, secret, user_name, password)
        @club = club
        @client_id = client_id
        @secret = secret
        @user_name = user_name
        @password = password
      end

      # gets the POST payload
      def get_payload
        {
            client_id: @client_id,
            client_secret: @secret,
            username: @user_name,
            password: @password,
            grant_type: 'password'
        }
      end

      def get_uri
        "https://#{TidyClub.get_club_name}.tidyclub.com/oauth/token"
      end

    end
  end
end