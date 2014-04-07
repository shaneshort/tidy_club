require 'spec_helper'

describe TidyClub::Contact, '#all' do
  it 'should return a list of Contact\'s' do
    contacts = TidyClub::Contact.all

    contacts.each do |m|
      expect(m.class).to be(TidyClub::Contact)
    end
  end


end