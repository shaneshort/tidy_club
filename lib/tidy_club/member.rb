module TidyClub
  class Member
    # returns a list of all members that are in tidy club
    def self.all
      TidyClub.get_api.make_request TidyClub::Request::Member.new
    end
  end
end