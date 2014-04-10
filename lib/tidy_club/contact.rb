module TidyClub
  class Contact < ActiveResource::Base

    attr_accessor :id, :first_name, :last_name, :nick_name, :company, :email_address, :phone_number,
                  :address1, :city, :state, :country, :post_code,
                  :gender, :birthday, :facebook, :twitter, :details, :profile_image,
                  :created_at

    self.site = TidyClub.get_api_url
    ActiveResource::Base.headers['Authorization'] = "Bearer #{TidyClub.get_access_token}"
  end
end