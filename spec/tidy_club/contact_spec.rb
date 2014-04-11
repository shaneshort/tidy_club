require 'spec_helper'

describe TidyClub::Contact, '#all' do
  it 'should return a list of Contact\'s' do

	  @response = [{}]
	  ActiveResource::HttpMock.respond_to do |mock|
		  mock.get '/contacts.json', {}, @response
	  end

    contacts = TidyClub::Contact.all

    contacts.each do |m|
      expect(m.class).to be(TidyClub::Contact)
    end
  end


end