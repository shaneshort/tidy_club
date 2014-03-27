module TidyClub
  module Request
    class BaseRequest
      def get_payload
        raise RuntimeError, "Stop being lazy, implement the payload"
      end

      def get_uri
        uri = TidyClub.get_club_url TidyClub.get_club_name
      end
    end
  end
end