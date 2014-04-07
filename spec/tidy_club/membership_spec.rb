require 'spec_helper'

describe TidyClub::Membership, '#all' do
	it 'should return a list of Membership\'s' do
		members = TidyClub::Membership.all

		members.each do |m|
			expect(m.class).to be(TidyClub::Membership)
		end
	end


end