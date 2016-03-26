require "active_support/configurable"

module EA
  module AreaLookup
    class Configuration
      include ActiveSupport::Configurable
      config_accessor(:administrative_area_api_url)
    end

    def self.config
      @config ||= Configuration.new
    end

    def self.configure
      yield config
    end

    def self.reset
      @config = Configuration.new
    end
  end
end
