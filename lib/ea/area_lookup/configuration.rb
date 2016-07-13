module EA
  module AreaLookup
    class Configuration
      attr_accessor :area_api_url

      def initialize
        @area_api_url ||= "http://environment.data.gov.uk/ds/wfs"
      end
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
