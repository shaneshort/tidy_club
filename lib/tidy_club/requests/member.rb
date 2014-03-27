module TidyClub
  module Request
    class Member < TidyClub::Request::BaseRequest
      def get_payload
        false
      end
    end
  end
end