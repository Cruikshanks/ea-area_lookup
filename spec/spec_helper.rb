require "codeclimate-test-reporter"
CodeClimate::TestReporter.start
require "simplecov"
require "byebug"
require "vcr"
require "logger"
$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "ea/area_lookup"

# Stubexternal services = see https://github.com/vcr/vcr
VCR.configure do |config|
  # As per codeclimate "VCR [..] will prevent the codeclimate-test-reporter from
  # reporting results to codeclimate.com" Recieved this error when first
  # configuring integration to codeclimate and the fix is to add it to
  # ignore_hosts.
  config.ignore_hosts 'codeclimate.com'

  config.cassette_library_dir = "spec/cassettes"
  config.hook_into :webmock
  config.ignore_hosts "127.0.0.1"
  config.allow_http_connections_when_no_cassette = false
  config.default_cassette_options = {
    record: :once
  }
end

# Don't log anything during tests
EA::AreaLookup.logger = Logger.new("/dev/null")

RSpec.configure do |config|
  config.filter_run :focus
  config.run_all_when_everything_filtered = true
end
