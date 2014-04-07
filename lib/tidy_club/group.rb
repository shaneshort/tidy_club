module TidyClub
  class Group < BaseObject

    attr_accessor :id, :label, :description, :contacts_count, :logo_image
                  :created_at

    # returns a list of all members that are in tidy club
    # @param [Boolean] search Terms to search for
    def self.all(search = '')
      ret = []
      rq = TidyClub::Request::Groups.new
      rq.add_parameter('search_terms', search) unless search == ''
      TidyClub.get_api.make_request(rq).each do |row|
        ret << Group.new(row)
      end
      ret
    end
  end
end