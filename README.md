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

## Testing with RSpec
A test helper is included that provides methods that will stub calls to
EA::AreaLookup methods in RSpec tests.

The available mock methods are:

```
mock_ea_area_lookup_find_by_coordinates
mock_no_results_ea_area_lookup_find_by_coordinates
mock_failure_of_ea_area_lookup_find_by_coordinates
```

To enable them add this to the rspec configuration (for example, within a
 `RSpec.configure do |config|` block in a Rails app's `spec/rails_helper.rb`):

```ruby
config.include EA::AreaLookup::TestHelper::RspecMocks
```

This will make the methods defined in `lib/ea/area_lookup/test_helper/rspec_mocks.rb`
available within the host app's rspec tests. For example:

```ruby
describe "postcode lookup" do
  before do
    mock_ea_area_lookup_find_by_coordinates
  end

  it "some tests that use data returned by a coordinate lokup" do
    ....
    # Any EA::AreaLookup.find_by_coordinates calls made in this spec will return the same
    # mocked data, and no external requests will be made, so you don't need webmock/VCR.
    # You can pass any coord aruments and they will
    # always return the mocked data and will not echo back your input.
    # See test_helper/area_lookup.yml to examine the mock data that will be returned.
  end
end
```

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
