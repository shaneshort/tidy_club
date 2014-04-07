require 'spec_helper'

describe TidyClub::Email, '#all' do
  it 'should return a list of email\'s' do
    list = TidyClub::Email.all

    list.each do |m|
      expect(m.class).to be(TidyClub::Email)
    end
  end
end