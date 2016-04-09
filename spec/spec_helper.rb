require "codeclimate-test-reporter"
CodeClimate::TestReporter.start
require "simplecov"
require "byebug"
require "vcr"
require "logger"
$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "ea/area_lookup"

# Stubexternal services = see https://github.com/vcr/vcr
VCR.configure do |c|
  c.cassette_library_dir = "spec/cassettes"
  c.hook_into :webmock
  c.ignore_hosts "127.0.0.1"
  c.allow_http_connections_when_no_cassette = false
  c.default_cassette_options = {
    record: :once
  }
end

# Don't log anything during tests
EA::AreaLookup.logger = Logger.new("/dev/null")

RSpec.configure do |config|
  config.filter_run :focus
  config.run_all_when_everything_filtered = true
end
