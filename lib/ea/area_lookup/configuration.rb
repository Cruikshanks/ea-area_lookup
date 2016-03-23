require "active_support/configurable"

module EA::AreaLookup
  class Configuration
    include ActiveSupport::Configurable
    config_accessor(:yay)
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
