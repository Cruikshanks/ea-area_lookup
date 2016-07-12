module EA
  module AreaLookup
    class Configuration
      attr_accessor :administrative_area_api_url

      def initialize
        @administrative_area_api_url ||= "http://environment.data.gov.uk/ds/wfs"
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
