module TidyClub
  class Email < BaseObject

    attr_accessor :id, :subject, :body,
                  :created_at

    # returns a list of all members that are in tidy club
    # @param [Boolean] search Terms to search for
    def self.all
      ret = []
      rq = TidyClub::Request::Emails.new
      TidyClub.get_api.make_request(rq).each do |row|
        ret << Email.new(row)
      end
      ret
    end
  end
end