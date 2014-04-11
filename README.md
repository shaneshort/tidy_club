# TidyClub

This is a simple integration gem. It handles the authorisation of requests and provides some nice data structures in return

## Installation

Add this line to your application's Gemfile:

    gem 'tidy_club', git: 'github.com/bluntelk/tidy_club'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tidy_club

## Usage

If you want to have authenticated access to your TidyClub, go to the Settings -> Applications section of your TidyClub
and get the client ID and secret. You will need to provide these to the TidyClub gem in the setup call

	options = {club_name:'club-domain', client_id:'...', client_secret:'...',user_name:'...', password:'...'}
	client = TidyClub::Client.new(options)

or

	client = TidyClub::Client.new do |client|
		client.club_name = 'club-domain'
		client.client_id = '...'
		client.client_secret = '...'
		client.user_name = '...', password:'...'
	end

There is a Logger instance that is used, you can configure the amount of output with

	TidyClub.set_logger_level Logger::Severity::DEBUG

You can then call the various classes to get the information you require

	client.contact.all.each {|contact| ...}

The following API endpoints are available

	client.category
	client.club # singleton - use .find to get the data back
	client.contact
	client.deposit
	client.email
	client.event
	client.event.tickets
	client.event.payments
	client.expense
	client.group
	client.invoice
	client.meeting
	client.membership
	client.membership_levels
	client.task
	client.ticket
	client.user # create only

## Contributing

1. Fork it ( http://github.com/bluntelk/tidy_club/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
