module TidyClub
  class Contact < BaseObject

    attr_accessor :id, :first_name, :last_name, :created_at

    # returns a list of all members that are in tidy club
    # @param [Boolean] search Terms to search for
    # @param [Boolean] registered_only Whether or not to show only registered contacts
    def self.all(search = '', registered_only = false)
      ret = []
      rq = TidyClub::Request::Contacts.new
      rq.add_parameter("search_terms", search) unless search == ''
      rq.add_parameter("registered", true) if registered_only
      TidyClub.get_api.make_request(rq).each do |row|
        ret << Contact.new(row)
      end
      ret
    end
  end
end