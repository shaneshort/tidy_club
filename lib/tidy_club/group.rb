module TidyClub
  class Group < ActiveResource::Base

    attr_accessor :id, :label, :description, :contacts_count, :logo_image
                  :created_at

    self.site = TidyClub.get_api_url
    ActiveResource::Base.headers['Authorization'] = "Bearer #{TidyClub.get_access_token}"
  end
end