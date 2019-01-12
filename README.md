# BigCheck

BigCheck allows you a convenient way to lookup HCP information against the Dutch BIG register. The code currently only allows you to look-up doctor based on their registration number. This might be extended in the future.

## Installation

Currently, this hasn't been released as a gem yet. For installation, you can add this line to your application's Gemfile:

```ruby
gem 'big_check', git:"https://github.com/bo-oz/big_check.git"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install big_check

## Usage

Using the gem is pretty simple. You can call the `check_by_big` method directly after initiating the class:

```ruby
client = BigCheck::Client.new
client.check_by_big(123455)
```

This makes the call to the webservice and initializes a new object of the Client class. You can check validity of the result by calling the `valid?` method on the HCP object, that is set to the `hcp` getter. If this equals to true, you can then access the available information.

```ruby
client.hcp.valid?
# true

# currently the following information is available
client.hcp.birth_surname
client.hcp.mailing_name
client.hcp.prefix
client.hcp.initial
client.hcp.gender
client.hcp.profession
client.hcp.specialism
```
There's more information in the response, so you could access the response via:

```ruby
client.hcp.response

# Or access the raw original reponse, which is a Savon response object
client.response
```

That's it! Enjoy.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/big_check. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the BigCheck project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/big_check/blob/master/CODE_OF_CONDUCT.md).
