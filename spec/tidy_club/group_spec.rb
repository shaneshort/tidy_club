require 'spec_helper'

describe TidyClub::Group, '#all' do
  it 'should return a list of Groups\'s' do
    group = TidyClub::Group.all

    group.each do |m|
      expect(m.class).to be(TidyClub::Group)
    end
  end


end