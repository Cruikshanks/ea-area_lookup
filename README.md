# EA::AreaLookup

This ruby gem provides a means of looking up the Environnment Agency Administrative Area (e.g. 'Wessex')
for a given easting and northing. It wraps an API designed for this purpose.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ea-area_lookup'
```

And then execute:

    $ bundle

## Usage

### Rails

Create an intializer eg ```config/initializers/area_lookup.rb```

```ruby
EA::AreaLookup.configure do |config|
  config.administrative_area_api_url = "http://admin-area-api-base-url"
end
```

Now you can do the following:

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
Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt
that will allow you to experiment.
