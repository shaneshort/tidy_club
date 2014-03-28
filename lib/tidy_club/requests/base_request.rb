module TidyClub
  module Request
    class BaseRequest
      def get_payload
        raise RuntimeError, "Stop being lazy, implement the payload"
      end

      def get_uri
        get_club_url TidyClub.get_club_name
      end

      # returns the tidy club URL that we can use to make our API calls
      def get_club_url(club_name)
	      "https://#{club_name}.tidyclub.com/api/v1?"
      end

    end
  end
end