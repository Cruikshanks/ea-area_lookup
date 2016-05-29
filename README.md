# EA::AreaLookup

[![Build Status](https://travis-ci.org/EnvironmentAgency/ea-area_lookup.svg?branch=master)](https://travis-ci.org/EnvironmentAgency/ea-area_lookup)
[![Code Climate](https://codeclimate.com/github/EnvironmentAgency/ea-area_lookup/badges/gpa.svg)](https://codeclimate.com/github/EnvironmentAgency/ea-area_lookup)
[![Test Coverage](https://codeclimate.com/github/EnvironmentAgency/ea-area_lookup/badges/coverage.svg)](https://codeclimate.com/github/EnvironmentAgency/ea-area_lookup/coverage)
[![Gem Version](https://badge.fury.io/rb/ea-area_lookup.svg)](https://badge.fury.io/rb/ea-area_lookup)

This ruby gem provides a means of looking up the Environment Agency Administrative Area (e.g. 'Wessex')
for a given easting and northing. It wraps an API designed for this purpose.

## Installation

Add this line to your application's Gemfile

```ruby
gem 'ea-area_lookup'
```

And then update your dependencies by calling

```bash
bundle install
```

## Usage

### Rails

Create an intializer e.g. `config/initializers/area_lookup.rb`

```ruby
EA::AreaLookup.configure do |config|
  config.administrative_area_api_url = "http://admin-area-api-base-url"
end
```

Now you can do the following

```ruby
coords = EA::AreaLookup::Coordinates.new(easting: 123, northing: 456)
(or EA::AreaLookup::Coordinates.new(x: 123, y: 456))
result = EA::AreaLookup.find_by_coordinates(coords)
p result
=> {:area_id=>"XX", :code=>"WESSEX", :area_name=>"Wessex", :short_name=>"Wessex", :long_name=>"Wessex"}
```

Note that the `Coordinates` class accepts x and y synonymously with easting and northing.

## Development

After checking out the repo, run `bin/setup` to install dependencies.
Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing to this project

If you have an idea you'd like to contribute please log an issue.

All contributions should be submitted via a pull request.

## License

THIS INFORMATION IS LICENSED UNDER THE CONDITIONS OF THE OPEN GOVERNMENT LICENCE found at:

http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3

The following attribution statement MUST be cited in your products and applications when using this information.

>Contains public sector information licensed under the Open Government license v3

### About the license

The Open Government Licence (OGL) was developed by the Controller of Her Majesty's Stationery Office (HMSO) to enable information providers in the public sector to license the use and re-use of their information under a common open licence.

It is designed to encourage use and re-use of information freely and flexibly, with only a few conditions.
