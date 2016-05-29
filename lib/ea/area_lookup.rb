require "ea/area_lookup/version"
require "ea/area_lookup/configuration"
require "ea/area_lookup/errors"
require "ea/area_lookup/logger"
require "ea/area_lookup/coordinates"
require "ea/area_lookup/finders"
require "ea/area_lookup/test_helper/rspec_mocks"

module EA
  module AreaLookup
    extend Finders
  end
end
